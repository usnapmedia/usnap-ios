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
    self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.videoMaximumDuration = 30.0f;
    self.showsCameraControls = NO;
    self.navigationBarHidden = YES;
    self.toolbarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
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
        newRenderSize = CGSizeMake(adjustedSize.height * desiredAspectRatio, adjustedSize.height);
        //        t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(adjustedSize.width - newRenderSize.width) / 2.0);
        t1 = CGAffineTransformMakeTranslation(-(adjustedSize.width - newRenderSize.width) / 2.0, 0);

    } else {
        newRenderSize = CGSizeMake(adjustedSize.width, adjustedSize.width / desiredAspectRatio);
        //        t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(adjustedSize.height - newRenderSize.height) / 2.0);

        t1 = CGAffineTransformMakeTranslation(0, -(adjustedSize.height - newRenderSize.height) / 2.0);
    }

    // Make sure the square is portrait
    //    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);

    CGAffineTransform newTransform = CGAffineTransformConcat(clipVideoTrack.preferredTransform, t1);

    [transformer setTransform:newTransform atTime:kCMTimeZero];

    // add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];

    
    
    // Create an Export Path to store the cropped video
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *exportPath = [documentsPath stringByAppendingFormat:@"/CroppedVideo.mp4"];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];

    // Remove any prevouis videos at that path
    [[NSFileManager defaultManager] removeItemAtURL:exportUrl error:nil];

    // Export square video
    exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = exportUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;

    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // Edit the selected media
            WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
            controller.mediaURL = exporter.outputURL;
            [self.navigationController pushViewController:controller animated:YES];

        });
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *mediaURL = nil;

    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {
        mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (mediaURL == nil) {
            mediaURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        }

        [self cropVideo:mediaURL];
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

@end
