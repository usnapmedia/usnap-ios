//
//  SSOAdjustementsHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOAdjustementsHelper : NSObject

@property(nonatomic, weak) UIImage *imageToEdit;
@property(nonatomic, weak) UIImageView *imageViewToEdit;

#pragma mark - Getters

/**
 *  Get the contrast slider value
 *
 *  @return the value
 */
- (float)contrastSliderValue;

/**
 *  Get the brightness slider value
 *
 *  @return the value
 */
- (float)brightnessSliderValue;

#pragma mark - Setters

/**
 *  Set the brightness with the slider value
 *
 *  @param value the value
 */
- (void)setBrightnessWithSliderValue:(float)value;

/**
 *  Set the contrast with the slider value
 *
 *  @param value the value
 */
- (void)setContrastWithSliderValue:(float)value;

#pragma mark - Image editing

/**
 *  Adjust the image with the new values
 */
- (void)adjustImage;

@end
