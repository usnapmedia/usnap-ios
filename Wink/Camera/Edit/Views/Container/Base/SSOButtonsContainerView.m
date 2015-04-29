//
//  SSOButtonsContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-08.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOButtonsContainerView.h"

@implementation SSOButtonsContainerView

#pragma mark - Animations

/**
 *  Initialize animations variables
 */
- (void)initializeAnimations {

    self.alpha = 0.0f;
    // Set the color picker in and out rect
    self.viewInRect = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.viewOutRect = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

@end
