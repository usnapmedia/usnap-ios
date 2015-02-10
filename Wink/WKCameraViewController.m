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
@property (nonatomic, strong) WKCameraOverlayViewController *cameraOverlayController;
@end

@implementation WKCameraViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the camera view
    self.cameraImagePickerController = [[WKImagePickerController alloc] init];
    self.cameraImagePickerController.delegate = self;
    self.cameraImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraImagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.cameraImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.cameraImagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
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

#pragma mark - Image Picker Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = nil;
    NSURL *mediaURL = nil;
    
    // Image
    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeImage)) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    // Video
    else if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {
        mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (mediaURL == nil) {
            mediaURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        }
    }
    
    // Dismiss the media picker
    if (picker != self.cameraImagePickerController) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    // Edit the selected media
    WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
    controller.image = image;
    controller.mediaURL = mediaURL;
    [self.cameraImagePickerController pushViewController:controller animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // Dismis the media picker
    if (picker != self.cameraImagePickerController) {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Button Actions

- (void)presentMediaPickerControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock {
    
    [UIAlertView showWithTitle:NSLocalizedString(@"Photo or video?", @"") message:nil cancelButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"Video", @""), NSLocalizedString(@"Photo", @"")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
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
