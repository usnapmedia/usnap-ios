//
//  SSOAccessoryContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAccessoryContainerView.h"

@implementation SSOAccessoryContainerView

#pragma mark - Animations

/**
 *  Initialize animations variables
 */
- (void)initializeAnimations {

    self.alpha = 0.0f;
    // Set the view in and view out. The view is initialized out of frame, we simply slide it up by it's height
    // to put it back in the view
    //@FIXME Orientation
    self.viewInRect = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.viewOutRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
@end
