//
//  SSOThemeHelper.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOThemeHelper.h"

@implementation SSOThemeHelper

+ (UIColor *)firstColor {
    return [UIColor colorWithRed:62.f / 255.f green:75.f / 255.f blue:199.f / 255.f alpha:1];
}

+ (UIColor *)firstSecondaryColor {
    return [UIColor blueColor];
}

+ (UIColor *)secondColor {
    return [UIColor whiteColor];
}

+ (UIColor *)secondSecondaryColor {
    return [UIColor whiteColor];
}

+ (UIColor *)thirdColor {
    return [UIColor colorWithRed:237.0f / 255.0f green:237.0f / 255.0f blue:237.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)thirdSecondaryColor {
    return [UIColor grayColor];
}

+ (UIFont *)avenirHeavyFontWithSize:(CGFloat)size {

    return [UIFont fontWithName:@"Avenir-Heavy" size:size];
}

+ (UIFont *)avenirLightFontWithSize:(CGFloat)size {

    return [UIFont fontWithName:@"Avenir-Light" size:size];
}

+ (UIFont *)helveticaNeueFontWithSize:(CGFloat)size {

    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)helveticaNeueLightFontWithSize:(CGFloat)size {

    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)yummyCupcakesFontWithSize:(CGFloat)size {

    return [UIFont fontWithName:@"YummyCupcakes" size:size];
}

@end
