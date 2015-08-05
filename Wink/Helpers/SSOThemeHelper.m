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
#ifdef NEOMEDIA
    return [UIColor colorWithRed:235.f / 255.f green:0.f / 255.f blue:40.f / 255.f alpha:1];
#elif LIBERAL
    return [UIColor colorWithRed:214.f / 255.f green:32.f / 255.f blue:39.f / 255.f alpha:1];
#else
    return [UIColor colorWithRed:62.f / 255.f green:75.f / 255.f blue:199.f / 255.f alpha:1];
#endif
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

+ (UIColor *)tabBarColor {
    return [UIColor colorWithRed:30.0f / 255.f green:30.0f / 255.f blue:30.0f / 255.f alpha:0.9f];
}

+ (UIColor *)tabBarSelectedColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];
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
