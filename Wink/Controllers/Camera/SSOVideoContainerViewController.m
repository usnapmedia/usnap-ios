//
//  SSOVideoContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOVideoContainerViewController.h"
#import "WKImagePickerController.h"
#import "SSOCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WKEditMediaViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImage+FastttCamera.h"
#import "UIImage+FixOrientation.h"

#define kMaximumVideoLength 30.0f

@interface SSOVideoContainerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation SSOVideoContainerViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeVideoCamera];
}

#pragma mark - Utilities

- (void)initializeVideoCamera {
    // Setup the camera view
    self.delegate = self;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    self.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeVideo];
    self.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];

    //    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    //    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //    self.videoMaximumDuration = kMaximumVideoLength;
    self.showsCameraControls = NO;
    //        self.navigationBarHidden = YES;
    //        self.toolbarHidden = YES;
    //    self.edgesForExtendedLayout = UIRectEdgeAll;
    //    self.extendedLayoutIncludesOpaqueBars = NO;
}

/**
 *  Crop video into a square
 *
 *  @param mediaURL file location for video
 */
- (void)cropVideo:(NSURL *)mediaURL {
    AVAssetExportSession *exporter;

    // load our movie Asset
    AVAsset *asset = [AVAsset assetWithURL:mediaURL];

    // create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    // create a video composition and preset some settings
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    // here we are setting its render size to its height x height (Square)
    videoComposition.renderSize = CGSizeMake(fabsf(clipVideoTrack.naturalSize.height), fabsf(clipVideoTrack.naturalSize.height));

    // create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(30, 30));

    AVMutableVideoCompositionLayerInstruction *transformer =
        [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];

    CGSize newRenderSize;

    CGAffineTransform t1;

    // Set your desired output aspect ratio here. 1.0 for square, 16/9.0 for widescreen, etc.
    CGFloat desiredAspectRatio = self.view.bounds.size.height / self.view.bounds.size.width;
    CGSize naturalSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
    CGSize adjustedSize = CGSizeApplyAffineTransform(naturalSize, clipVideoTrack.preferredTransform);
    adjustedSize.width = ABS(adjustedSize.width);
    adjustedSize.height = ABS(adjustedSize.height);

    if (adjustedSize.width > adjustedSize.height) {
        newRenderSize = CGSizeMake(adjustedSize.width, adjustedSize.width / desiredAspectRatio);

        t1 = CGAffineTransformMakeTranslation(-(adjustedSize.width - newRenderSize.width) / 2.0, adjustedSize.width);

    } else {
        newRenderSize = CGSizeMake(adjustedSize.height * desiredAspectRatio, adjustedSize.height);

        t1 = CGAffineTransformMakeTranslation(adjustedSize.height, -(adjustedSize.height - newRenderSize.height) / 2.0);
    }

    videoComposition.renderSize = newRenderSize;

    // Make sure the square is portrait
    CGAffineTransform newTransform = CGAffineTransformConcat(clipVideoTrack.preferredTransform, t1);

    [transformer setTransform:newTransform atTime:kCMTimeZero];

    // add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];

    // Create an Export Path to store the cropped video
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *exportPath = [documentsPath stringByAppendingFormat:@"/CroppedVideo.mp4"];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];

    // Remove any previous videos at that path
    [[NSFileManager defaultManager] removeItemAtURL:exportUrl error:nil];

    // Export square video
    exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = exportUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;

    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // Dismiss HUD
            [SVProgressHUD dismiss];

            [self.videoDelegate enableUserInteraction];

            // Edit the selected media
            WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
            controller.mediaURL = exporter.outputURL;
            [self.navigationController pushViewController:controller animated:YES];

        });
    }];
}

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

    //    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {
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

    } else if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {

        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];

        [self cropVideo:videoURL];
    }

    // Dismiss the media picker
    if (picker != self) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    // Dismis the media picker
    if (picker != self) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Utilities

- (void)turnRearCameraOff {
    // Make sure that the source type is UIImagePickerControllerSourceTypeCamera before setting the camera device. It'll crash otherwise
    self.sourceType = UIImagePickerControllerSourceTypeCamera;

    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
}

- (void)turnRearCameraOn {
    // Make sure that the source type is UIImagePickerControllerSourceTypeCamera before setting the camera device. It'll crash otherwise
    self.sourceType = UIImagePickerControllerSourceTypeCamera;

    self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}

@end
