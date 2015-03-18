//
//  SSOContainerViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOContainerViewController.h"
#import "WKImagePickerController.h"

@interface SSOContainerViewController ()

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
        _photoContainerVC = [[SSOPhotoContainerViewController alloc] init];
    }
    return _photoContainerVC;
}

/**
 *  Lazy instanciation of the controllers
 *
 *  @return the controller
 */
- (SSOVideoContainerViewController *)videoContainerVC {
    if (!_videoContainerVC) {

        _videoContainerVC = [[SSOVideoContainerViewController alloc] init];
    }
    return _videoContainerVC;
}

@end
