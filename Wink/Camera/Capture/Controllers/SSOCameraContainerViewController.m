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

@interface SSOCameraContainerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FastttCameraDelegate>

@end

@implementation SSOCameraContainerViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;

    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.view.frame;
}

#pragma mark - Utilities

#pragma mark Capture Photo and Video

- (void)capturePhoto {
    [self.fastCamera takePicture];
}

- (void)startRecordingVideo {
    [self.fastCamera startRecordingVideo];
}

- (void)stopRecordingVideo {
    [self.fastCamera stopRecordingVideo];
}

#pragma mark Flash

- (void)turnFlashOn {
    if ([FastttCamera isFlashAvailableForCameraDevice:self.fastCamera.cameraDevice]) {
        [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOn];
    }
}

- (void)turnFlashAuto {
    if ([FastttCamera isFlashAvailableForCameraDevice:self.fastCamera.cameraDevice]) {
        [self.fastCamera setCameraFlashMode:FastttCameraFlashModeAuto];
    }
}

- (void)turnFlashOff {
    if ([FastttCamera isFlashAvailableForCameraDevice:self.fastCamera.cameraDevice]) {
        [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOff];
    }
}

#pragma mark Read and Front Camera

- (void)turnOnFrontCamera {
    if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceFront]) {
        [self.fastCamera setCameraDevice:FastttCameraDeviceFront];
    }
}

- (void)turnOnRearCamera {
    if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceRear]) {
        [self.fastCamera setCameraDevice:FastttCameraDeviceRear];
    }
}

#pragma mark - FastttCameraDelegate

- (void)cameraController:(FastttCamera *)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {
    // Edit the selected media
    WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
    controller.image = capturedImage.fullImage;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishRecordingVideo:(NSURL *)videoURL {
    [SSOVideoEditingHelper cropVideo:videoURL
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

@end