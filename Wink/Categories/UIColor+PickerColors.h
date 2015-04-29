//
//  UIColor+PickerColors.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PickerColors)

/**
 *  Get the array of colors for the picker view
 *
 *  @return the array
 */
+(NSArray *)colorsArray;

/**
 *  Get the array of greyscale for the picker view
 *
 *  @return the array
 */
+(NSArray *)grayscaleArray;

@end
