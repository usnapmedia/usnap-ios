//
//  WKNavigationController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKNavigationController.h"
#import "WKShareViewController.h"
#import "Constants.h"

@implementation WKNavigationController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

/**
 *  Make the status bar disapear when it will present the camera
 *
 *  @param animated bool value
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}


@end
