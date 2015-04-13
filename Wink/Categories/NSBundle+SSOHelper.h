//
//  NSBundle+SSOHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrightnessContrastSlidersContainerView.h"
#import "SSOColorPickerContainerView.h"
#import "SSOLoginContainerView.h"
#import "SSORegisterContainerView.h"

@interface NSBundle (SSOHelper)

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

+ (SSOLoginContainerView *)loadLoginContainerView;

+ (SSORegisterContainerView *)loadRegisterContainerView;

@end
