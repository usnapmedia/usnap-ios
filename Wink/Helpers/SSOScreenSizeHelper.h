//
//  SSOScreenSizeHelper.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOScreenSizeHelper : NSObject

/**
 *  Set the height of the bottomView for login/register
 *
 *  @return the height
 */
+ (NSNumber *)heightForRegisterBottomView;

/**
 *  Set the bottom margin for register/login textFields
 *
 *  @return the bottom margin
 */
+ (NSNumber *)bottomMarginForTextField;

/**
 *  Get the height for the campaign VC based on the iphone
 *
 *  @return the height
 */
+ (CGFloat)campaignViewControllerHeightConstraint;

@end
