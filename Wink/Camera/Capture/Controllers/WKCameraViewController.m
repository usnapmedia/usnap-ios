//
//  WKCameraViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKCameraViewController.h"
#import "WKCameraOverlayViewController.h"
#import "WKNavigationController.h"
#import "WKSettingsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WKEditMediaViewController.h"

@interface WKCameraViewController ()

@property(nonatomic, strong) WKCameraOverlayViewController *cameraOverlayController;
@property(nonatomic) CGSize screenSize;

@end

@implementation WKCameraViewController

#pragma mark - View Methods

- (void)takePhoto:(id)sender {
    [self.photoCamera takePicture];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.screenSize = [[UIScreen mainScreen] bounds].size;

    // Initialize photo camera
    [self initializeFastCamera];

    // Setup the camera view
    self.cameraImagePickerController = [[WKImagePickerController alloc] init];
    self.cameraImagePickerController.delegate = self;
    self.cameraImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraImagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.cameraImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.cameraImagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.cameraImagePickerController.videoMaximumDuration = 30.0f;
    self.cameraImagePickerController.showsCameraControls = NO;
    self.cameraImagePickerController.navigationBarHidden = YES;
    self.cameraImagePickerController.toolbarHidden = YES;
    self.cameraImagePickerController.edgesForExtendedLayout = UIRectEdgeAll;
    self.cameraImagePickerController.extendedLayoutIncludesOpaqueBars = NO;
    self.cameraImagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];

    // Setup the camera overlay view controller
    self.cameraOverlayController = [[WKCameraOverlayViewController alloc] initWithNibName:@"WKCameraOverlayViewController" bundle:nil];
    self.cameraOverlayController.cameraController = self;
    self.cameraOverlayController.view.frame = self.cameraImagePickerController.view.bounds;
    self.cameraImagePickerController.cameraOverlayView = self.cameraOverlayController.view;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self presentViewController:self.cameraImagePickerController animated:NO completion:nil];
}

#pragma mark - Utilities

- (void)initializeFastCamera {
    self.photoCamera = [FastttCamera new];
    self.photoCamera.delegate = self;

    self.photoCamera.maxScaledDimension = 600.f;

    [self fastttAddChildViewController:self.photoCamera];
    self.photoCamera.view.frame = self.view.frame;
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
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);

    // create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(30, 30));

    AVMutableVideoCompositionLayerInstruction *transformer =
        [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];

    // Need to convert the height of the top black bar to the right screen size with the right 2x or 3x.
    // The offset is how much of the video is clipped
    // You divide by 568 because you're taking the ratio of the XIB of the screen that the overlay was created on
    // @FIXME: The ratio should be fixed with constraints. Not sure about about the 2x or 3x

    float offset = (self.cameraOverlayController.topViewHeightConstraint.constant * self.screenSize.height * 3) / 568;

    // Use this code if you want the viewing square to be below the black top bar
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -offset);

    // Make sure the square is portrait
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);

    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];

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
        [self.cameraImagePickerController pushViewController:controller animated:YES];

      });
    }];
}

#pragma mark - Image Picker Methods

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
    if (picker != self.cameraImagePickerController) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    // Dismis the media picker
    if (picker != self.cameraImagePickerController) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Button Actions

- (void)presentMediaPickerControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock {

    [UIAlertView showWithTitle:NSLocalizedString(@"Photo or video?", @"")
                       message:nil
             cancelButtonTitle:nil
             otherButtonTitles:@[ NSLocalizedString(@"Video", @""), NSLocalizedString(@"Photo", @"") ]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {

                        BOOL allowsEditing = NO;
                        NSArray *mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
                        if (buttonIndex == 0) {
                            allowsEditing = YES;
                            mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
                        }

                        WKImagePickerController *controller = [[WKImagePickerController alloc] init];
                        controller.delegate = self;
                        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        controller.videoMaximumDuration = 30.0f;
                        controller.allowsEditing = allowsEditing;
                        controller.navigationBarHidden = NO;
                        controller.toolbarHidden = NO;
                        controller.mediaTypes = mediaTypes;
                        if (!self.isPhone) {
                            controller.modalPresentationStyle = UIModalPresentationFormSheet;
                        }
                        [self.navigationController.visibleViewController presentViewController:controller animated:animated completion:completionBlock];
                      }];
}

- (void)presentSettingsControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock {
    WKSettingsViewController *controller = [[WKSettingsViewController alloc] initWithNibName:@"WKSettingsViewController" bundle:nil];
    WKNavigationController *navController = [[WKNavigationController alloc] initWithRootViewController:controller];
    if (!self.isPhone) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self.navigationController.visibleViewController presentViewController:navController animated:animated completion:completionBlock];
}

@end
