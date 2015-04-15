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
#import "SSOLoginViewController.h"

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

/**
 *  Get the login container view
 *
 *  @return the view
 */
+ (SSOLoginContainerView *)loadLoginContainerView;

/**
 *  Get the register container view
 *
 *  @return the view
 */
+ (SSORegisterContainerView *)loadRegisterContainerView;

/**
 *  Get the login view controller
 *
 *  @return the VC
 */
+ (SSOLoginViewController *)loadLoginViewController;

@end
