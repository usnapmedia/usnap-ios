//
//  SSOContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOContainerViewController.h"
#import "WKImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SSOContainerViewController ()

@property(strong, nonatomic) UIViewController *currentVC;

@end

@implementation SSOContainerViewController

@synthesize cameraContainerVC = _cameraContainerVC;

#pragma mark - Utilities

- (void)setInitialViewController {
    UIViewController *initialVC = self.cameraContainerVC;
    self.currentVC = initialVC;
    [self addChildViewController:initialVC];
    UIView *destView = ((UIViewController *)initialVC).view;
    destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:initialVC.view];

    [initialVC didMoveToParentViewController:self];
}

#pragma mark - Getters

/**
 *  Lazy instanciation of the controllers
 *
 *  @return the controller
 */
- (SSOCameraContainerViewController *)cameraContainerVC {
    if (!_cameraContainerVC) {

        _cameraContainerVC = [[SSOCameraContainerViewController alloc] init];
    }
    return _cameraContainerVC;
}

@end
