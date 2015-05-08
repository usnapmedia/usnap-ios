//
//  SSOScreenSizeHelper.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOScreenSizeHelper.h"
#import <SDiPhoneVersion.h>

CGFloat const kImageWidthToHeightRatio = 0.33f;
NSInteger const kCampaignCellLabelHeight = 40;

@implementation SSOScreenSizeHelper

+ (NSNumber *)bottomMarginForTextField {

    NSNumber *margin;

    DeviceVersion model = [SDiPhoneVersion deviceVersion];

    if (model == iPhone4S || model == iPhone4) {
        margin = @5;
    } else if (model == iPhone5 || model == iPhone5S) {

        margin = @10;
    } else if (model == iPhone6 || model == iPhone6Plus) {

        margin = @1;
    }

    return margin;
}

+ (NSNumber *)heightForRegisterBottomView {

    NSNumber *height;

    DeviceVersion model = [SDiPhoneVersion deviceVersion];

    if (model == iPhone4S || model == iPhone4) {
        height = @50;
    } else if (model == iPhone5 || model == iPhone5S) {

        height = @60;
    } else if (model == iPhone6 || model == iPhone6Plus) {

        height = @80;
    }

    return height;
}

+ (CGFloat)campaignViewControllerHeightConstraint {
    // Get the screen size
    CGSize screenSize = kScreenSize;
    // Calculate the image height based on the given ratio
    CGFloat imageHeight = screenSize.width * kImageWidthToHeightRatio;
    // Add the size of the label to get the total height
    return kCampaignCellLabelHeight + imageHeight;
}

@end
