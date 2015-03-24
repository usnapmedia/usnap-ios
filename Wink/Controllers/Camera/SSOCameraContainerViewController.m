//
//  SSOVideoContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraContainerViewController.h"
#import "WKImagePickerController.h"
#import "SSOCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WKEditMediaViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImage+FastttCamera.h"
#import "UIImage+Tools.h"
#import "SSOVideoEditingHelper.h"
#import "CoreGraphics/CoreGraphics.h"
#import "CoreVideo/CoreVideo.h"
#import "CoreMedia/CoreMedia.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import "FastttCamera.h"

#define kMaximumVideoLength 30.0f

@interface SSOCameraContainerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureFileOutputRecordingDelegate>

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) AVCaptureMovieFileOutput *movieFileOutput;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property(strong, nonatomic) AVCaptureSession *session;

@end

@implementation SSOCameraContainerViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCamera];
}

#pragma mark - Utilities

- (void)initializeCamera {
    //    // Setup the camera view
    //    self.delegate = self;
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    //        self.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    }
    //
    //    self.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    //    self.showsCameraControls = NO;
    //    self.videoQuality = UIImagePickerControllerQualityTypeHigh;

    self.session = [[AVCaptureSession alloc] init];
    // session is global object.
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.frame;
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    NSLog(@"start      3");
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"Error");
    }
    [self.session addInput:input];

    [self.session beginConfiguration];

    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [self.session addOutput:self.movieFileOutput];

    [self.session commitConfiguration];

    [self.session startRunning];
    //    [self performSelector:@selector(startRecording) withObject:nil afterDelay:10.0];
    //[aMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    // previously i used to do this way but saw people doing it after delay thought it might be taking some time to initialized so tried this way also.
}

- (void)capturePhoto {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }

    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                           CFDictionaryRef exifAttachments =
                                                               CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                           if (exifAttachments) {
                                                               // Do something with the attachments.
                                                               NSLog(@"attachements: %@", exifAttachments);
                                                           } else
                                                               NSLog(@"no attachments");

                                                           NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                           UIImage *image = [[UIImage alloc] initWithData:imageData];

                                                           CGRect cropRect = [image fastttCropRectFromPreviewLayer:self.previewLayer];

                                                           CGFloat desiredRatio = self.view.frame.size.height / self.view.frame.size.width;

                                                           if (cropRect.size.height > cropRect.size.width) {
                                                               cropRect = CGRectMake(cropRect.origin.x, cropRect.origin.y, cropRect.size.height,
                                                                                     cropRect.size.height * desiredRatio);

                                                           } else {

                                                               cropRect = CGRectMake(cropRect.origin.x, cropRect.origin.y, cropRect.size.height * desiredRatio,
                                                                                     cropRect.size.height);
                                                           }

                                                           // Newly cropped image with correct size and translation
                                                           CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
                                                           UIImage *croppedImage =
                                                               [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
                                                           CGImageRelease(imageRef);
                                                           UIImage *newImage = [croppedImage fixOrientation];

                                                           // Edit the selected media
                                                           WKEditMediaViewController *controller =
                                                               [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
                                                           controller.image = image;
                                                           [self.navigationController pushViewController:controller animated:YES];

                                                       }];
}

- (void)startRecordingVideo {
    NSLog(@"startRecording");
    NSString *plistPath;
    NSString *rootPath;
    rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"test.mov"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:plistPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) {
    }
    [self.movieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

- (void)stopRecordingVideo {
    [self.movieFileOutput stopRecording];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
    didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                        fromConnections:(NSArray *)connections
                                  error:(NSError *)error {
    NSLog(@"sofijsdofij");

    NSLog(@"outputFileURL :%@", outputFileURL);

    [SSOVideoEditingHelper cropVideo:outputFileURL
                          withStatus:^(AVAssetExportSessionStatus status, AVAssetExportSession *exporter) {
                              switch (status) {
                              case AVAssetExportSessionStatusUnknown:
                                  [SVProgressHUD dismiss];
                                  [self.videoDelegate enableUserInteraction];

                                  break;
                              case AVAssetExportSessionStatusWaiting:
                                  break;
                              case AVAssetExportSessionStatusExporting:
                                  break;
                              case AVAssetExportSessionStatusCompleted: {
                                  // Dismiss HUD
                                  [SVProgressHUD dismiss];
                                  [self.videoDelegate enableUserInteraction];

                                  // Edit the selected media
                                  WKEditMediaViewController *controller =
                                      [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
                                  controller.mediaURL = exporter.outputURL;
                                  [self.navigationController pushViewController:controller animated:YES];
                              } break;
                              case AVAssetExportSessionStatusFailed:
                                  [SVProgressHUD dismiss];
                                  [self.videoDelegate enableUserInteraction];

                                  break;
                              case AVAssetExportSessionStatusCancelled:
                                  [SVProgressHUD dismiss];
                                  [self.videoDelegate enableUserInteraction];

                                  break;

                              default:
                                  break;
                              }
                          }
                     inContainerView:self.view];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"sofijsdofij");
}

//-(void)setSession:(AVCaptureSession *)session
//{
//    NSLog(@"setting session...");
//    self.captureSession=session;
//}

#pragma mark - UIImagePickerControllerDelegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    UIImage *imageFromCamera = nil;
//    NSURL *videoURL = nil;
//
//    // If the user took a picture
//    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeImage)) {
//
//        imageFromCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
//        if (imageFromCamera == nil) {
//            imageFromCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
//
//        UIImage *newImage = [imageFromCamera cropImage:imageFromCamera inContainView:self.view];
//
//        // Edit the selected media
//        WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
//        controller.image = newImage;
//        [self.navigationController pushViewController:controller animated:YES];
//
//        // If the user took a video
//    } else if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {
//
//        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        [SSOVideoEditingHelper cropVideo:videoURL
//                              withStatus:^(AVAssetExportSessionStatus status, AVAssetExportSession *exporter) {
//                                  switch (status) {
//                                  case AVAssetExportSessionStatusUnknown:
//                                      [SVProgressHUD dismiss];
//                                      [self.videoDelegate enableUserInteraction];
//
//                                      break;
//                                  case AVAssetExportSessionStatusWaiting:
//                                      break;
//                                  case AVAssetExportSessionStatusExporting:
//                                      break;
//                                  case AVAssetExportSessionStatusCompleted: {
//                                      // Dismiss HUD
//                                      [SVProgressHUD dismiss];
//                                      [self.videoDelegate enableUserInteraction];
//
//                                      // Edit the selected media
//                                      WKEditMediaViewController *controller =
//                                          [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
//                                      controller.mediaURL = exporter.outputURL;
//                                      [self.navigationController pushViewController:controller animated:YES];
//                                  } break;
//                                  case AVAssetExportSessionStatusFailed:
//                                      [SVProgressHUD dismiss];
//                                      [self.videoDelegate enableUserInteraction];
//
//                                      break;
//                                  case AVAssetExportSessionStatusCancelled:
//                                      [SVProgressHUD dismiss];
//                                      [self.videoDelegate enableUserInteraction];
//
//                                      break;
//
//                                  default:
//                                      break;
//                                  }
//                              }
//                         inContainerView:self.view];
//    }
//
//    // Dismiss the media picker
//    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//
//    // Dismis the media picker
//    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Utilities

//- (void)turnRearCameraOff {
//    // Make sure that the source type is UIImagePickerControllerSourceTypeCamera before setting the camera device. It'll crash otherwise
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        self.sourceType = UIImagePickerControllerSourceTypeCamera;
//
//        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
//            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//        }
//    }
//}
//
//- (void)turnRearCameraOn {
//    // Make sure that the source type is UIImagePickerControllerSourceTypeCamera before setting the camera device. It'll crash otherwise
//
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        self.sourceType = UIImagePickerControllerSourceTypeCamera;
//
//        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
//            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
//        }
//    }
//}
//
//- (void)flashTurnedOn {
//    if ([UIImagePickerController isFlashAvailableForCameraDevice:self.cameraDevice]) {
//        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
//    }
//}
//
//- (void)flashTurnedOff {
//    if ([UIImagePickerController isFlashAvailableForCameraDevice:self.cameraDevice]) {
//        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
//    }
//}

@end
