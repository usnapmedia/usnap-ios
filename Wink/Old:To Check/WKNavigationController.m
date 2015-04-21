//
//  WKNavigationController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKNavigationController.h"
#import "WKShareViewController.h"

@implementation WKNavigationController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self.visibleViewController isKindOfClass:[WKShareViewController class]]) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[WKShareViewController class]]) {

        // if the current orientation is not already portrait, we need this hack in order to set the root back to portrait
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation != UIInterfaceOrientationPortrait) {

            // HACK: setting the root view controller to nil and back again "resets" the navigation bar to the correct orientation
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            UIViewController *vc = window.rootViewController;
            window.rootViewController = nil;
            window.rootViewController = vc;
        }
    }
}


@end
