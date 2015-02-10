//
//  WKImagePickerController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-16.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKImagePickerController.h"

@implementation WKImagePickerController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
