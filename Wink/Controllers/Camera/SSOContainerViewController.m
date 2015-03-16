//
//  SSOContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOContainerViewController.h"
#import "SSOPhotoContainerViewController.h"
#import "SSOVideoContainerViewController.h"
#import "WKImagePickerController.h"

@interface SSOContainerViewController ()

/**
 *  View controllers available inside the container
 */
@property(strong, nonatomic) SSOPhotoContainerViewController *photoContainerVC;
//@property(strong, nonatomic) SSOVideoContainerViewController *videoContainerVC;

@property(nonatomic, strong) WKImagePickerController *videoContainerVC;

@property(strong, nonatomic) UIViewController *currentVC;

@end

@implementation SSOContainerViewController

@synthesize photoContainerVC = _photoContainerVC;
@synthesize videoContainerVC = _videoContainerVC;

#pragma mark - Utilities

- (UIViewController *)viewControllerByType:(ContainerViewControllerType)type {
    switch (type) {
    case PhotoContainerCamera:
        return self.photoContainerVC;
        break;

    case VideoContainerCamera:
        return self.videoContainerVC;
        break;

    default:
        break;
    }

    return nil;
}

- (void)setInitialViewController:(ContainerViewControllerType)viewControllerType {
    UIViewController *initialVC = [self viewControllerByType:viewControllerType];
    self.currentVC = initialVC;
    [self addChildViewController:initialVC];
    UIView *destView = ((UIViewController *)initialVC).view;
    destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:initialVC.view];

    [initialVC didMoveToParentViewController:self];
}

- (void)swapToViewControllerOfType:(ContainerViewControllerType)type {
    [self swapFromViewController:self.currentVC toViewController:[self viewControllerByType:type]];
}

/**
 *  Swap view controllers in the container
 *
 *  @param fromViewController previous view controller
 *  @param toViewController   next view controller
 */
- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {

    // If the selected view is the same as the current, don't change
    if (fromViewController == toViewController)
        return;

    // Disable the user interaction while transitioning, else there may be errors in the view controllers stack
    [self.parentViewController.view setUserInteractionEnabled:NO];

    // Set the view frame and alpha to 0 for transitionning
    toViewController.view.frame = fromViewController.view.bounds;
    toViewController.view.alpha = 0.0;

    // Add the view controller and signal that it will move
    [self addChildViewController:toViewController];
    [fromViewController willMoveToParentViewController:nil];

    // Transition to the other view controller
    [self transitionFromViewController:fromViewController
        toViewController:toViewController
        duration:0.5
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            fromViewController.view.alpha = 0.0;
            toViewController.view.alpha = 1.0;
        }
        completion:^(BOOL finished) {
            // Remove the other view controller
            [toViewController didMoveToParentViewController:self];
            [fromViewController removeFromParentViewController];
            // Set current view controller
            self.currentVC = toViewController;
            // Re-enable the user interaction
            [self.parentViewController.view setUserInteractionEnabled:YES];
        }];
}

#pragma mark - Getters

/**
 *  Lazy instanciation of the controllers
 *
 *  @return the controller
 */
- (SSOPhotoContainerViewController *)photoContainerVC {
    if (!_photoContainerVC) {
        _photoContainerVC = [[UIStoryboard cameraStoryboard] instantiateViewControllerWithIdentifier:PHOTO_CONTAINER_VC];
    }
    return _photoContainerVC;
}

/**
 *  Lazy instanciation of the controllers
 *
 *  @return the controller
 */
- (WKImagePickerController *)videoContainerVC {
    if (!_videoContainerVC) {

        _videoContainerVC = [[WKImagePickerController alloc] init];
        //        _videoContainerVC.delegate = self;
        _videoContainerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _videoContainerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _videoContainerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //        self.cameraImagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
        //        self.cameraImagePickerController.videoMaximumDuration = 30.0f;
        _videoContainerVC.showsCameraControls = NO;
        _videoContainerVC.navigationBarHidden = YES;
        _videoContainerVC.toolbarHidden = YES;
        //        self.cameraImagePickerController.edgesForExtendedLayout = UIRectEdgeAll;
        //        self.cameraImagePickerController.extendedLayoutIncludesOpaqueBars = NO;
        _videoContainerVC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    return _videoContainerVC;
}

@end
