//
//  NSBundle+Wink.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "NSBundle+Wink.h"

@implementation NSBundle (Wink)

+ (SSOColorPickerContainerView *)loadColorPickerContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSOColorPickerContainerView" owner:self options:nil] firstObject];
}

+ (SSODrawAccessoryContainerView *)loadDrawAccessoryContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSODrawAccessoryContainerView" owner:self options:nil] firstObject];
}

+ (SSOTextAccessoryContainerView *)loadTextAccessoryContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSOTextAccessoryContainerView" owner:self options:nil] firstObject];
}

+ (SSOAdjustmentAccessoryContainerView *)loadAdjustAccessorryContainerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SSOAdjustmentAccessoryContainerView" owner:self options:nil] firstObject];
}

@end
