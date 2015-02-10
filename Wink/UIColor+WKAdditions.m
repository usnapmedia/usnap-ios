//
//  UIColor+WKAdditions.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-04.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "UIColor+WKAdditions.h"

@implementation UIColor (WKAdditions)

+ (UIColor *)yellowTextColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.98f green:0.86f blue:0.54f alpha:alpha];
}

+ (UIColor *)lightGreyTextColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.66f green:0.66f blue:0.66f alpha:alpha];
}

+ (UIColor *)purpleTextColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.36f green:0.41f blue:0.70f alpha:alpha];
}

+ (UIColor *)purpleColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.58f green:0.54f blue:0.99f alpha:alpha];
}

+ (UIColor *)greenColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.53f green:0.62f blue:0.34f alpha:alpha];
}

@end
