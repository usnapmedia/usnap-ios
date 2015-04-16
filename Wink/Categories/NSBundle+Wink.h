//
//  NSBundle+Wink.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSOColorPickerContainerView.h"
#import "SSODrawAccessoryContainerView.h"
#import "SSOTextAccessoryContainerView.h"
#import "SSOAdjustmentAccessoryContainerView.h"

@interface NSBundle (Wink)

/**
 *  Get the color picker container view
 *
 *  @return the view
 */
+ (SSOColorPickerContainerView *)loadColorPickerContainerView;

/**
 *  Get the draw accessory container view
 *
 *  @return the view
 */
+ (SSODrawAccessoryContainerView *)loadDrawAccessoryContainerView;

/**
 *  Get the text accessory container view
 *
 *  @return the view
 */
+ (SSOTextAccessoryContainerView *)loadTextAccessoryContainerView;

/**
 *  Get the adjustment accessory container view
 *
 *  @return the view
 */
+ (SSOAdjustmentAccessoryContainerView *)loadAdjustAccessorryContainerView;

@end
