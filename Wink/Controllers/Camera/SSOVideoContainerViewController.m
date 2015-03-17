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

@end
