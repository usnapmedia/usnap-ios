//
//  NSBundle+SSOHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "NSBundle+SSOHelper.h"

@implementation NSBundle (SSOHelper)

+ (BrightnessContrastSlidersView *)loadBrightnessContrastSliderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BrightnessContrastSliderView" owner:self options:nil] firstObject];
}


@end
