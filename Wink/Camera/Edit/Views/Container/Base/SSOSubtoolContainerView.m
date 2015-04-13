//
//  SSOSubtoolContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSubtoolContainerView.h"

@implementation SSOSubtoolContainerView

#pragma mark - Animations

/**
 *  Initialize animations variables
 */
- (void)initializeAnimations {

    self.alpha = 0.0f;
    // Set the container rect in and out. The view is originally out, we simply add it's height to slide it in.
    self.viewInRect = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.viewOutRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

@end
