//
//  UINavigationController+SSOLockedNavigationController.m
//  Wink
//
//  Created by Nicolas VINCENSINI on 2015-04-09.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "UINavigationController+SSOLockedNavigationController.h"

@implementation UINavigationController (SSOLockedNavigationController)


-(BOOL)shouldAutorotate {
    
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
