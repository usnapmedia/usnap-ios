//
//  SSOBrightnessContrastHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAccessoryHelper.h"

@interface SSOBrightnessContrastHelper : SSOAccessoryHelper

/**
 *  Set the view with the sliders
 *
 *  @param view the view
 */
- (void)setView:(BrightnessContrastSlidersContainerView *)view;
@end
