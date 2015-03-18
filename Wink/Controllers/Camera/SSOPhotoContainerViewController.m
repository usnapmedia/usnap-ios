//
//  SSOPhotoContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOPhotoContainerViewController.h"
#import "FastttCamera.h"
#import "WKEditMediaViewController.h"
#import <Masonry.h>

@interface SSOPhotoContainerViewController () <FastttCameraDelegate>

@property(nonatomic, strong) FastttCamera *photoCamera;

@end

@implementation SSOPhotoContainerViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupCamera];
}

#pragma mark - Utilities

- (void)setupCamera {
    self.photoCamera = [FastttCamera new];
    self.photoCamera.delegate = self;

    [self fastttAddChildViewController:self.photoCamera];

    [self.photoCamera.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height. and.width.lessThanOrEqualTo(self.view.mas_width).with.priorityHigh();
        make.height. and.width.lessThanOrEqualTo(self.view.mas_height).with.priorityHigh();
        make.height. and.width.equalTo(self.view.mas_width).with.priorityLow();
        make.height. and.width.equalTo(self.view.mas_height).with.priorityLow();
    }];
}

- (void)flashTurnedOn {
    if ([FastttCamera isFlashAvailableForCameraDevice:self.photoCamera.cameraDevice]) {
        [self.photoCamera setCameraFlashMode:FastttCameraFlashModeOn];
    }
}

- (void)flashTurnedOff {
    if ([FastttCamera isFlashAvailableForCameraDevice:self.photoCamera.cameraDevice]) {
        [self.photoCamera setCameraFlashMode:FastttCameraFlashModeOff];
    }
}

- (void)rearCameraTurnedOn {
    if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceFront]) {
        [self.photoCamera setCameraDevice:FastttCameraDeviceFront];
    }
}

- (void)rearCameraTurnedOff {
    if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceRear]) {
        [self.photoCamera setCameraDevice:FastttCameraDeviceRear];
    }
}

- (void)takePhoto {
    [self.photoCamera takePicture];
}

#pragma mark - FastttCameraDelegate

- (void)cameraController:(FastttCamera *)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {
    // Save image
    // Edit the selected media
    WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
    controller.image = capturedImage.scaledImage;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
