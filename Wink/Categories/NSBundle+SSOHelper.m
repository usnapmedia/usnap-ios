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

+ (SSOLoginContainerView *)loadLoginContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSOLoginContainerView" owner:self options:nil] firstObject];
}

+ (SSORegisterContainerView *)loadRegisterContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSORegisterContainerView" owner:self options:nil] firstObject];
}

@end
