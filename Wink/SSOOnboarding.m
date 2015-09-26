//
//  SSOOnboarding.m
//  uSnap
//
//  Created by Yanick Lavoie on 2015-09-24.
//  Copyright © 2015 Samsao. All rights reserved.
//
// We are subclassing the pod to prevent altering it.  We need to block rotation but doing it in the pod would prevent
// from being able to upgrade it if other versions gets released.
//


#import "SSOOnboarding.h"

@implementation SSOOnboarding

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
