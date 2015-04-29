//
//  UIColor+PickerColors.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "UIColor+PickerColors.h"

@implementation UIColor (PickerColors)

+ (NSArray *)colorsArray {
    return [NSArray arrayWithObjects:[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor redColor], nil];
}

+ (NSArray *)grayscaleArray {
    return [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], nil];
}

@end
