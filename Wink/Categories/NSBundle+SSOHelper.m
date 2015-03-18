//
//  NSBundle+SSOHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "NSBundle+SSOHelper.h"

@implementation NSBundle (SSOHelper)

+ (BrightnessContrastSlidersContainerView *)loadBrightnessContrastContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BrightnessContrastContainerView" owner:self options:nil] firstObject];
}

+ (SSOColorPickerContainerView *)loadColorPickerContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ColorPickerContainerView" owner:self options:nil] firstObject];
}

@end
