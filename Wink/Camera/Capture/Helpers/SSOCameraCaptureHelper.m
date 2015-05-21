//
//  SSOCameraCaptureHelper.m
//  Wink
//
//  Created by Justin Khan on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraCaptureHelper.h"
#import "UIImage+Resize.h"
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

static void *CapturingStillImageContext = &CapturingStillImageContext;
static void *RecordingContext = &RecordingContext;
static void *SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface SSOCameraCaptureHelper () <AVCaptureFileOutputRecordingDelegate>

@property(nonatomic, weak) AVCamPreviewView *previewView;

// Session management.
@property(nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property(nonatomic) AVCaptureSession *session;
@property(nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property(nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property(nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property(nonatomic) id runtimeErrorHandlingObserver;

@end

@implementation SSOCameraCaptureHelper

- (BOOL)isSessionRunningAndDeviceAuthorized {
    return [[self session] isRunning];
}

- (instancetype)initWithPreviewView:(AVCamPreviewView *)previewView
                     andOrientation:(UIDeviceOrientation)orientation
                 withDevicePosition:(AVCaptureDevicePosition)devicePosition
                     withFlashState:(AVCaptureFlashMode)flashState {

    if (self = [super init]) {

        // Check if there is a AVCapture session. Allow the app to launch with simulator
        if ([AVCaptureDevice devices].count) {

            // Create the AVCaptureSession
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            [self setSession:session];

            self.previewView = previewView;

            // Setup the preview view
            [[self previewView] setSession:session];

            // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
            // Why not do all of this on the main queue?
            // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main
            // queue
            // isn't blocked (which keeps the UI responsive).

            dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
            [self setSessionQueue:sessionQueue];

            dispatch_async(sessionQueue, ^{
              [self setBackgroundRecordingID:UIBackgroundTaskInvalid];

              NSError *error = nil;

              AVCaptureDevice *videoDevice = [SSOCameraCaptureHelper deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
              AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];

              if (error) {
                  NSLog(@"%@", error);
              }

              if ([session canAddInput:videoDeviceInput]) {
                  [session addInput:videoDeviceInput];
                  [self setVideoDeviceInput:videoDeviceInput];

                  dispatch_async(dispatch_get_main_queue(), ^{
                    // Why are we dispatching this to the main queue?
                    // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                    // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s
                    // connection with other session manipulation.

                    [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)orientation];
                    [(AVCaptureVideoPreviewLayer *)[self.previewView layer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                  });
              }

              AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
              if ([session canAddOutput:movieFileOutput]) {
                  [session addOutput:movieFileOutput];
                  AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
                  if ([connection isVideoStabilizationSupported])
                      [connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
                  [self setMovieFileOutput:movieFileOutput];
              }

              AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
              if ([session canAddOutput:stillImageOutput]) {
                  [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
                  [session addOutput:stillImageOutput];
                  [self setStillImageOutput:stillImageOutput];
              }

              [[NSNotificationCenter defaultCenter] addObserver:self
                                                       selector:@selector(subjectAreaDidChange:)
                                                           name:AVCaptureDeviceSubjectAreaDidChangeNotification
                                                         object:[[self videoDeviceInput] device]];

              [[self session] startRunning];

              // Set the position of the camera on initialization
              [self changeCameraWithDevicePosition:devicePosition];
              [SSOCameraCaptureHelper setFlashMode:flashState forDevice:[[self videoDeviceInput] device]];
            });
        }
    }
    return self;
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
    [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
}

- (void)dealloc {

    //          [[self session] stopRunning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
    [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
    // dispatch_async([self sessionQueue], ^{
    //      [[self session] stopRunning];

    //      self.session = nil;

    //      [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self
    //      videoDeviceInput] device]];
    //      [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
    //
    //      [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
    //      [self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
    //      [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    //                   });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

    [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == CapturingStillImageContext) {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];

        if (isCapturingStillImage) {
            [self runStillImageCaptureAnimation];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Actions

- (void)toggleMovieRecording {
    //@FIXME: This removed the red bar on the status bar, but It's not good when the user starts to record a video
    NSError *error = nil;
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];

    if ([self.session canAddInput:audioDeviceInput]) {
        [self.session addInput:audioDeviceInput];
    }
    dispatch_async([self sessionQueue], ^{
      if (![[self movieFileOutput] isRecording]) {

          if ([[UIDevice currentDevice] isMultitaskingSupported]) {
              // Setup background task. This is needed because the captureOutput:didFinishRecordingToOutputFileAtURL: callback is not received until AVCam
              // returns to the foreground unless you request background execution time. This also ensures that there will be time to write the file to the
              // assets library when AVCam is backgrounded. To conclude this background execution, -endBackgroundTask is called in
              // -recorder:recordingDidFinishToOutputFileURL:error: after the recorded file has been saved.
              [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
          }

          // Update the orientation on the movie file output video connection before starting recording.
          [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo]
              setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];

          // Turning OFF flash for video recording
          //          [SSOCameraCaptureHelper setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];

          // Start recording to a temporary file.
          NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
          [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
      } else {
          [[self movieFileOutput] stopRecording];
      }

    });
}

- (void)changeCameraWithDevicePosition:(AVCaptureDevicePosition)devicePosition {
    AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];

    AVCaptureDevice *videoDevice = [SSOCameraCaptureHelper deviceWithMediaType:AVMediaTypeVideo preferringPosition:devicePosition];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];

    [[self session] beginConfiguration];

    [[self session] removeInput:[self videoDeviceInput]];
    if ([[self session] canAddInput:videoDeviceInput]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];

        [SSOCameraCaptureHelper setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(subjectAreaDidChange:)
                                                     name:AVCaptureDeviceSubjectAreaDidChangeNotification
                                                   object:videoDevice];

        [[self session] addInput:videoDeviceInput];
        [self setVideoDeviceInput:videoDeviceInput];
    } else {
        [[self session] addInput:[self videoDeviceInput]];
    }

    [[self session] commitConfiguration];
}

- (void)snapStillImage {
    dispatch_async([self sessionQueue], ^{
      AVCaptureVideoOrientation orientation;
      if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
          orientation = AVCaptureVideoOrientationLandscapeRight;
      } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
          orientation = AVCaptureVideoOrientationLandscapeLeft;

      } else {
          orientation = AVCaptureVideoOrientationPortrait;
      }

      // Update the orientation on the still image output video connection before capturing.
      [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:orientation];

      // Capture a still image.
      [[self stillImageOutput]
          captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo]
                                      completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

                                        if (imageDataSampleBuffer) {
                                            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                            UIImage *tempImg = [[UIImage alloc] initWithData:imageData];
                                            UIImage *image =
                                                [self squareImageWithImage:tempImg scaledToSize:CGSizeMake(tempImg.size.width, tempImg.size.height)];
                                            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                            NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

                                            [library saveImage:image
                                                            toAlbum:appName
                                                withCompletionBlock:^(NSError *error) {
                                                  [self removeObservers];
                                                  [self.delegate didFinishCapturingImage:image withError:error];
                                                }];
                                        }
                                      }];
    });
}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer]
        captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus
                  exposeWithMode:AVCaptureExposureModeContinuousAutoExposure
                   atDevicePoint:devicePoint
        monitorSubjectAreaChange:NO];
}

#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
    didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                        fromConnections:(NSArray *)connections
                                  error:(NSError *)error {
    if (error)
        NSLog(@"%@", error);

    // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a
    // new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens
    // sometime after this method returns.
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

    [library addAssetURL:outputFileURL
                    toAlbum:appName
        withCompletionBlock:^(NSError *error) {
          [self removeObservers];
          [self.delegate didFinishCapturingVideo:outputFileURL withError:error];
        }];
}

#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode
              exposeWithMode:(AVCaptureExposureMode)exposureMode
               atDevicePoint:(CGPoint)point
    monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    dispatch_async([self sessionQueue], ^{
      AVCaptureDevice *device = [[self videoDeviceInput] device];
      NSError *error = nil;
      if ([device lockForConfiguration:&error]) {
          if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
              [device setFocusMode:focusMode];
              [device setFocusPointOfInterest:point];
          }
          if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
              [device setExposureMode:exposureMode];
              [device setExposurePointOfInterest:point];
          }
          [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
          [device unlockForConfiguration];
      } else {
          NSLog(@"%@", error);
      }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device {
    if ([device hasFlash] && [device isFlashModeSupported:flashMode]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
}

+ (void)setTorchMode:(AVCaptureTorchMode)torchMode forDevice:(AVCaptureDevice *)device {
    if ([device hasTorch] && [device isTorchModeSupported:torchMode]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setTorchMode:torchMode];
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];

    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }

    return captureDevice;
}

#pragma mark Camera Photo Tools

/**
 *  Make the photo took by the user square
 *
 *  @param image  image from the camera
 *  @param newSize the size of the image
 *
 *  @return the squared photo
 */

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    NSInteger lowestSide;
    UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(image.size.width, image.size.width)
                                         interpolationQuality:kCGInterpolationHigh];
    // Crop the image to a square (yikes, fancy!)
    return [scaledImage croppedImage:CGRectMake((scaledImage.size.width - image.size.width) / 2, (scaledImage.size.height - image.size.height) / 2,
                                                image.size.width, image.size.height)];
}

#pragma mark UI

- (void)runStillImageCaptureAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
      [[[self previewView] layer] setOpacity:0.0];
      [UIView animateWithDuration:.25
                       animations:^{
                         [[[self previewView] layer] setOpacity:1.0];
                       }];
    });
}

@end
