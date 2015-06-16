//
//  SSOCameraCaptureHelper.m
//  Wink
//
//  Created by Justin Khan on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraCaptureHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "SSSessionManager.h"

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
@property(nonatomic) AVCaptureDevicePosition devicePosition;

// Utilities.
@property(nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property(nonatomic) id runtimeErrorHandlingObserver;

@end

@implementation SSOCameraCaptureHelper

#pragma mark - Initialization

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
              self.devicePosition = devicePosition;

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

- (void)dealloc {
    [self removeObservers];
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

#pragma mark - Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

    [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)toInterfaceOrientation];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Called when the photo is being taken
    if (context == CapturingStillImageContext) {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        // If the image is being taken, display the animation
        if (isCapturingStillImage) {
            [self runStillImageCaptureAnimation];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/**
 *  Remove Observers
 */

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
    [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Actions

/**
 *  This method is called when the user start a long gesture and is called again when the long gesture is done
 */

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
          [[SSSessionManager sharedInstance] setLastPhotoOrientation:[UIDevice currentDevice].orientation];
          [[self movieFileOutput] stopRecording];
      }

    });
}

/**
 *  Take the photo
 */

- (void)snapStillImage {
    dispatch_async([self sessionQueue], ^{
      // Set the photo orientation based on the device orientation
      AVCaptureVideoOrientation orientation;
      //      if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
      //          orientation = AVCaptureVideoOrientationLandscapeRight;
      //      } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
      //          orientation = AVCaptureVideoOrientationLandscapeLeft;
      //
      //      } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
      //          orientation = AVCaptureVideoOrientationPortraitUpsideDown;
      //
      //      } else {
      [[SSSessionManager sharedInstance] setLastPhotoOrientation:[UIDevice currentDevice].orientation];

      orientation = AVCaptureVideoOrientationPortrait;
      //      }

      // Update the orientation on the still image output video connection before capturing.
      [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:orientation];

      // Capture a still image.
      [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo]
                                                           completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

                                                             if (imageDataSampleBuffer) {
                                                                 NSData *imageData =
                                                                     [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                                 UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                                 //                                                                 UIImage *image = [self
                                                                 //                                                                 squareImageWithImage:tempImg];
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

#pragma mark - Camera

/**
 *  Flipping the camera
 *
 *  @param devicePosition orientation of the capture device
 */
- (void)changeCameraWithDevicePosition:(AVCaptureDevicePosition)devicePosition {
    AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
    self.devicePosition = devicePosition;
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

/**
 *  Focus and expose of the camera on the tap gesture. We get the focus point based on the gesture
 *
 *  @param gestureRecognizer tap gesture
 */

//@FIXME: This is not being used
- (void)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)[[self previewView] layer]
        captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

/**
 *  Called when the focus object of the camera change. We will focus after
 *
 *  @param notification the notification
 */

- (void)subjectAreaDidChange:(NSNotification *)notification {
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus
                  exposeWithMode:AVCaptureExposureModeContinuousAutoExposure
                   atDevicePoint:devicePoint
        monitorSubjectAreaChange:NO];
}

/**
 *  Changing the focus mode
 *
 *  @param focusMode                focusMode
 *  @param exposureMode             exposureMode
 *  @param point                    point in the view
 *  @param monitorSubjectAreaChange YES if you want to track the subject changes
 */

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

/**
 *  Changing the flash mode of the device
 *
 *  @param flashMode flashMode
 *  @param device    device
 */

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

/**
 *  Setting the torch mode
 *
 *  @param torchMode torchMode
 *  @param device    device
 */

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

/**
 *  Get the capture device based on the type
 *
 *  @param mediaType mediaType
 *  @param position  position
 *
 *  @return return the capture device
 */

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

#pragma mark - AVCaptureFileOutputRecordingDelegate

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
          [self rotateVideo:outputFileURL];
          [self.delegate didFinishCapturingVideo:outputFileURL withError:nil];
          //          [self cropVideoSquare:outputFileURL];
        }];
}

#pragma mark - Utilities
/**
 *  Make the photo took by the user square
 *
 *  @param image  image from the camera
 *
 *  @return the squared photo
 */

- (UIImage *)squareImageWithImage:(UIImage *)image {
    // Set the size of the image to be the smallest side of the photo
    CGFloat newSize = MIN(image.size.width, image.size.height);
    CGAffineTransform scaleTransform;
    CGPoint origin;
    // figure out if the picture is landscape or portrait, then calculate scale factor and offset
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    // start a new context, with scale factor 0.0 so retina displays get high quality image
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    [image drawAtPoint:origin];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

/**
 *  This method will receive the video URL and crop the video square
 *
 *  @param url video URL
 */

- (void)cropVideoSquare:(NSURL *)url {

    // load our movie Asset
    AVAsset *asset = [AVAsset assetWithURL:url];
    // create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    CGFloat newSize = MIN(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
    UIImageOrientation videoOrientation = [self getVideoOrientationFromDeviceOrientation];

    CGFloat cropOffX = 0;
    CGFloat cropOffY = 0;
    CGFloat cropWidth = newSize;
    CGFloat cropHeight = newSize;

    // If it's landscape, crop the X
    if (videoOrientation == UIImageOrientationLeft || videoOrientation == UIImageOrientationRight || videoOrientation == UIImageOrientationLeftMirrored ||
        videoOrientation == UIImageOrientationRightMirrored) {
        cropOffX = -(clipVideoTrack.naturalSize.height - clipVideoTrack.naturalSize.width) / 2.0f;
    } else {
        // Else crop the Y
        cropOffY = -(clipVideoTrack.naturalSize.height - clipVideoTrack.naturalSize.width) / 2.0f;
    }

    // create a video composition and preset some settings
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);

    videoComposition.renderSize = CGSizeMake(cropWidth, cropHeight);

    // create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));

    // Create the transform to change the video output
    AVMutableVideoCompositionLayerInstruction *transformer =
        [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    CGAffineTransform t1 = CGAffineTransformIdentity;
    CGAffineTransform t2 = CGAffineTransformIdentity;

    // Set the transforms based on the orientation
    if (videoOrientation == UIImageOrientationUp) {
        t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height - cropOffX, 0 - cropOffY);
        t2 = CGAffineTransformRotate(t1, M_PI_2);
    } else if (videoOrientation == UIImageOrientationDown) {
        t1 = CGAffineTransformMakeTranslation(0 - cropOffX, clipVideoTrack.naturalSize.width - cropOffY); // not fixed width is the real height in upside down
        t2 = CGAffineTransformRotate(t1, -M_PI_2);
    } else if (videoOrientation == UIImageOrientationRight && self.devicePosition == AVCaptureDevicePositionBack) {
        t1 = CGAffineTransformMakeTranslation(0 - cropOffX, 0);
        t2 = CGAffineTransformRotate(t1, 0);
    } else if (videoOrientation == UIImageOrientationRight && self.devicePosition == AVCaptureDevicePositionFront) {
        t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width - cropOffX, clipVideoTrack.naturalSize.height);
        t2 = CGAffineTransformRotate(t1, M_PI);
    } else if (videoOrientation == UIImageOrientationLeft && self.devicePosition == AVCaptureDevicePositionFront) {
        t1 = CGAffineTransformMakeTranslation(0 - cropOffX, 0);
        t2 = CGAffineTransformRotate(t1, 0);
    } else if (videoOrientation == UIImageOrientationLeft && self.devicePosition == AVCaptureDevicePositionBack) {
        t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width - cropOffX, clipVideoTrack.naturalSize.height);
        t2 = CGAffineTransformRotate(t1, M_PI);
    } else {
        NSLog(@"no supported orientation has been found in this video");
        return;
    }

    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];

    // add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];

    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"croppedMovie" stringByAppendingPathExtension:@"mp4"]];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];

    // Remove any prevouis videos at that path
    [[NSFileManager defaultManager] removeItemAtURL:exportUrl error:nil];
    // Export
    exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = exportUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
      dispatch_async(dispatch_get_main_queue(), ^{
        // Call when finished
        [self.delegate didFinishCapturingVideo:exportUrl withError:nil];
      });
    }];
}

- (void)rotateVideo:(NSURL *)url {
    UIImageOrientation videoOrientation = [self getVideoOrientationFromDeviceOrientation];
    if (videoOrientation == UIImageOrientationLeft || videoOrientation == UIImageOrientationRight || videoOrientation == UIImageOrientationLeftMirrored ||
        videoOrientation == UIImageOrientationRightMirrored) {
        // load our movie Asset
        AVAsset *asset = [AVAsset assetWithURL:url];
        // create an avassetrack with our asset
        AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        // create a video composition and preset some settings
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.frameDuration = CMTimeMake(1, 30);
        NSLog(@"witdh: %f, height: %f", clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.width);
        videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
        // create a video instruction
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));
        // Create the transform to change the video output
        AVMutableVideoCompositionLayerInstruction *transformer =
            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
        CGAffineTransform t1 = CGAffineTransformIdentity;
        CGAffineTransform t2 = CGAffineTransformIdentity;

        // Set the transforms based on the orientation
        if (videoOrientation == UIImageOrientationRight && self.devicePosition == AVCaptureDevicePositionBack) {
            t1 = CGAffineTransformMakeTranslation(0, 0);
            t2 = CGAffineTransformRotate(t1, 0);
        } else if (videoOrientation == UIImageOrientationRight && self.devicePosition == AVCaptureDevicePositionFront) {
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
            t2 = CGAffineTransformRotate(t1, M_PI);
        } else if (videoOrientation == UIImageOrientationLeft && self.devicePosition == AVCaptureDevicePositionFront) {
            t1 = CGAffineTransformMakeTranslation(0, 0);
            t2 = CGAffineTransformRotate(t1, 0);
        } else if (videoOrientation == UIImageOrientationLeft && self.devicePosition == AVCaptureDevicePositionBack) {
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
            t2 = CGAffineTransformRotate(t1, M_PI);
        } else {
            NSLog(@"no supported orientation has been found in this video");
            return;
        }

        CGAffineTransform finalTransform = t2;
        [transformer setTransform:finalTransform atTime:kCMTimeZero];

        // add the transformer layer instructions, then add to video composition
        instruction.layerInstructions = [NSArray arrayWithObject:transformer];
        videoComposition.instructions = [NSArray arrayWithObject:instruction];

        NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"croppedMovie" stringByAppendingPathExtension:@"mp4"]];
        NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];

        // Remove any prevouis videos at that path
        [[NSFileManager defaultManager] removeItemAtURL:exportUrl error:nil];
        // Export
        exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
        exporter.videoComposition = videoComposition;
        exporter.outputURL = exportUrl;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
          dispatch_async(dispatch_get_main_queue(), ^{
            // Call when finished

            AVAsset *asset2 = [AVAsset assetWithURL:exportUrl];
            // create an avassetrack with our asset
            AVAssetTrack *clipVideoTrack2 = [[asset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            // create a video composition and preset some settings
            AVMutableVideoComposition *videoComposition2 = [AVMutableVideoComposition videoComposition];
            videoComposition2.frameDuration = CMTimeMake(1, 30);
            NSLog(@"new witdh: %f, new height: %f", clipVideoTrack2.naturalSize.width, clipVideoTrack2.naturalSize.height);

            [[SSSessionManager sharedInstance] setLastVideoURL:exportUrl];
          });
        }];

    } else {
        [[SSSessionManager sharedInstance] setLastVideoURL:url];
    }
}

/**
 *  Get the orientation of the device on the moment of the photo
 *
 *  @return the image orientation
 */

- (UIImageOrientation)getVideoOrientationFromDeviceOrientation {
    UIImageOrientation orientation;
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        orientation = UIImageOrientationRight;
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        orientation = UIImageOrientationLeft;

    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        orientation = UIImageOrientationUp;

    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
        orientation = UIImageOrientationDown;

    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp) {
        orientation = UIImageOrientationUp;

    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationFaceDown) {
        orientation = UIImageOrientationUp;
    }
    return orientation;
}

#pragma mark UI

/**
 *  Fading effect of the action of taking a photo
 */

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
