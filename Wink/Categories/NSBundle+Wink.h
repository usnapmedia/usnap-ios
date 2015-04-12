//
//  NSBundle+Wink.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrightnessContrastSlidersContainerView.h"
#import "SSOColorPickerContainerView.h"
#import "SSODrawAccessoryContainerView.h"

@interface NSBundle (Wink)

/**
 *  Get the brightness contrast container view
 *
 *  @return the view
 */
+ (BrightnessContrastSlidersContainerView *)loadBrightnessContrastContainerView;

/**
 *  Get the color picker container view
 *
 *  @return the view
 */
+ (SSOColorPickerContainerView *)loadColorPickerContainerView;

/**
 *  Get the draw accessory container view
 *
 *  @return the view
 */
+(SSODrawAccessoryContainerView *)loadDrawAccessoryContainerView;

@end
