//
//  SSONavigationControllerNoRotation.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSONavigationControllerNoRotation.h"

@implementation SSONavigationControllerNoRotation

- (BOOL)shouldAutorotate {
    NSLog(@" vc : %@", self.topViewController);
    //return YES;
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"orientation %lu for vc : %@", (unsigned long)self.topViewController.supportedInterfaceOrientations, self.topViewController);

 //   return UIDeviceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
    return self.visibleViewController.supportedInterfaceOrientations;
}

@end
