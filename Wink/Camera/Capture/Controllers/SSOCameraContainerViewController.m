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
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#define kMaximumVideoLength 30.0f

@interface SSOCameraContainerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FastttCameraDelegate>

@property(strong, atomic) ALAssetsLibrary *library;

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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self initializeAssetsLibrary];
}

#pragma mark - Utilities

#pragma mark Capture Photo and Video

- (void)capturePhoto {
    _capturing = YES;
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
    [self.library saveImage:controller.image
                    toAlbum:@"uSnap"
        withCompletionBlock:^(NSError *error) {
          if (error) {
              NSLog(@"Error saving image in camera roll: %@", [error description]);
          }
        }];
    [self.navigationController pushViewController:controller animated:YES];
    _capturing = NO;
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

                                
                                
                                NSURLRequest *request = [NSURLRequest requestWithURL:exporter.outputURL];
                                
                                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
                                    NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[exporter.outputURL lastPathComponent]];
                                    [data writeToURL:tempURL atomically:YES];
                                    UISaveVideoAtPathToSavedPhotosAlbum(tempURL.path, nil, NULL, NULL);
                                }];

                                
                                
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

/**
 *  Initialize the camera library and display the last picture in cameraRoll imageView
 */
- (void)initializeAssetsLibrary {
    self.library = [[ALAssetsLibrary alloc] init];

    //[SVProgressHUD showWithStatus:NSLocalizedString(@"loading", nil)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
          usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            //                                    [SVProgressHUD dismiss];

            if (group != nil) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];

                [group enumerateAssetsWithOptions:NSEnumerationReverse
                                       usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {

                                         if (asset) {
                                             UIImage *img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
                                             self.libraryImage = img;

                                             *stop = YES;
                                         }
                                       }];
            }

            *stop = NO;
          }
          failureBlock:^(NSError *error) {
            //[SVProgressHUD dismiss];

            NSLog(@"error %@", error);
          }];

    });
}

@end
