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
#import "UIImage+FixOrientation.h"
#import "AVAsset+VideoOrientation.h"

#define kMaximumVideoLength 30.0f

@interface SSOCameraContainerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation SSOCameraContainerViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeVideoCamera];
}

#pragma mark - Utilities

- (void)initializeVideoCamera {
    // Setup the camera view
    self.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
    }

    self.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    self.showsCameraControls = NO;
}

// @TODO: Move method to category for AVAssetExportSession
// @TODO: Add comments
// @TODO: Simplify

/**
 *  Crop video into a square
 *
 *  @param mediaURL file location for video
 */
- (void)cropVideo:(NSURL *)mediaURL withStatus:(void (^)(AVAssetExportSessionStatus, AVAssetExportSession *))statusBlock {
    __block AVAssetExportSession *exporter;

    // load our movie Asset
    AVAsset *asset = [AVAsset assetWithURL:mediaURL];

    // create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    // Create a video composition and preset some settings
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);

    // Set your desired output aspect ratio here. 1.0 for square, 16/9.0 for widescreen, etc.
    CGFloat desiredAspectRatio = self.view.bounds.size.height / self.view.bounds.size.width;

    // Here we are setting its render size to its height x height (Square)
    CGSize naturalSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
    CGSize adjustedSize = CGSizeApplyAffineTransform(naturalSize, clipVideoTrack.preferredTransform);
    adjustedSize.width = ABS(adjustedSize.width);
    adjustedSize.height = ABS(adjustedSize.height);

    CGFloat newHeight = clipVideoTrack.naturalSize.height * desiredAspectRatio;
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, newHeight);

    // Create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];

    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));

    AVMutableVideoCompositionLayerInstruction *transformer =
        [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];

    CGAffineTransform finalTransform = [AVAsset fixOrientationWithAsset:asset withVideoComposition:videoComposition withView:self.view];
    [transformer setTransform:finalTransform atTime:kCMTimeZero];

    // Add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];

    // Create an Export Path to store the cropped video
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *exportPath = [documentsPath stringByAppendingFormat:@"/CroppedVideo.mp4"];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];

    // Remove any previous videos at that path
    [[NSFileManager defaultManager] removeItemAtURL:exportUrl error:nil];

    // Export video
    exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;

    exporter.outputURL = exportUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;

    // @TODO: Add error handling
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            statusBlock(exporter.status, exporter);

        });
    }];
}

// @FIXME: Doesn't crop perfectly well
// @TODO: Remove FastttCamera
// @TODO: Add comments
// @TODO: Move to category
// @TODO: Simplify

- (UIImage *)cropImage:(UIImage *)image {

    CGSize newRenderSize;
    CGAffineTransform t1;

    CIImage *coreImage = [CIImage imageWithCGImage:image.CGImage];

    // Set your desired output aspect ratio here. 1.0 for square, 16/9.0 for widescreen, etc.
    CGFloat desiredAspectRatio = self.view.bounds.size.height / self.view.bounds.size.width;
    CGSize naturalSize = CGSizeMake(image.size.width, image.size.height);
    CGSize adjustedSize = naturalSize;

    adjustedSize.width = ABS(naturalSize.height);
    adjustedSize.height = ABS(naturalSize.width);

    if (adjustedSize.width > adjustedSize.height) {
        newRenderSize = CGSizeMake(adjustedSize.height * desiredAspectRatio, adjustedSize.height);
        t1 = CGAffineTransformMakeTranslation(-(adjustedSize.width - newRenderSize.width) / 2.0, 0);

    } else {
        newRenderSize = CGSizeMake(adjustedSize.height, adjustedSize.width);
        t1 = CGAffineTransformMakeTranslation(0, -(adjustedSize.height - newRenderSize.height) / 2.0);
    }

    coreImage = [coreImage imageByApplyingTransform:t1];

    CGRect rect = CGRectMake(coreImage.extent.origin.x, coreImage.extent.origin.y, newRenderSize.width, newRenderSize.height);
    UIImage *imageWithCorrectSize = [image fastttCroppedImageFromCropRect:rect];

    return [imageWithCorrectSize fixOrientation];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *imageFromCamera = nil;
    NSURL *videoURL = nil;

    // If the user took a picture
    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeImage)) {

        imageFromCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (imageFromCamera == nil) {
            imageFromCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        UIImage *newImage = [self cropImage:imageFromCamera];

        // Edit the selected media
        WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
        controller.image = newImage;
        [self.navigationController pushViewController:controller animated:YES];

        // If the user took a video
    } else if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {

        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [self cropVideo:videoURL
             withStatus:^(AVAssetExportSessionStatus status, AVAssetExportSession *exporter) {
                 switch (status) {
                 case AVAssetExportSessionStatusUnknown:
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
                     WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
                     controller.mediaURL = exporter.outputURL;
                     [self.navigationController pushViewController:controller animated:YES];
                 } break;
                 case AVAssetExportSessionStatusFailed:

                     break;
                 case AVAssetExportSessionStatusCancelled:
                     break;

                 default:
                     break;
                 }
             }];
    }

    // Dismiss the media picker
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    // Dismis the media picker
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utilities

- (void)turnRearCameraOff {
    // Make sure that the source type is UIImagePickerControllerSourceTypeCamera before setting the camera device. It'll crash otherwise
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    }
}

- (void)turnRearCameraOn {
    // Make sure that the source type is UIImagePickerControllerSourceTypeCamera before setting the camera device. It'll crash otherwise

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
}

- (void)flashTurnedOn {
    if ([UIImagePickerController isFlashAvailableForCameraDevice:self.cameraDevice]) {
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
}

- (void)flashTurnedOff {
    if ([UIImagePickerController isFlashAvailableForCameraDevice:self.cameraDevice]) {
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

@end
