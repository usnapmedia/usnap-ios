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

@interface SSOVideoContainerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) WKImagePickerController *cameraImagePickerController;
@property (nonatomic, strong) SSOCameraViewController *overlay;

@end

@implementation SSOVideoContainerViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeVideoCamera];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self presentViewController:self.cameraImagePickerController animated:NO completion:nil];
}

#pragma mark - Utilities

- (void)initializeVideoCamera {
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

//    self.overlay = [[UIStoryboard cameraStoryboard] instantiateViewControllerWithIdentifier:CAMERA_VC];
//    self.cameraImagePickerController.cameraOverlayView = self.overlay.view;
////    self.overlay.containerView.hidden = YES;

}

@end
