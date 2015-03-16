//
//  SSOPhotoContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOPhotoContainerViewController.h"
#import "FastttCamera.h"

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
    self.photoCamera.view.frame = self.view.frame;
}

@end
