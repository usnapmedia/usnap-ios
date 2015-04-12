//
//  NSBundle+Wink.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "NSBundle+Wink.h"

@implementation NSBundle (Wink)

+ (BrightnessContrastSlidersContainerView *)loadBrightnessContrastContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BrightnessContrastContainerView" owner:self options:nil] firstObject];
}

+ (SSOColorPickerContainerView *)loadColorPickerContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ColorPickerContainerView" owner:self options:nil] firstObject];
}

+ (SSODrawAccessoryContainerView *)loadDrawAccessoryContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSODrawAccessoryContainerView" owner:self options:nil] firstObject];
}

@end
