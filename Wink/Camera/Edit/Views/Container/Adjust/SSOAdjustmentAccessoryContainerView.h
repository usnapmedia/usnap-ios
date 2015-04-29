//
//  SSOAdjustAccessoryContainerView.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOContainerViewDelegate.h"

@protocol SSOAdjustmentContainerViewDelegate;

@interface SSOAdjustmentAccessoryContainerView : UIView

@property(weak, nonatomic) id<SSOAdjustmentContainerViewDelegate> delegate;

@end

@protocol SSOAdjustmentContainerViewDelegate <SSOContainerViewDelegate>

/**
 *  Called when brightness button is pressed
 *
 *  @param view the view
 */
- (void)adjustmentContainerDidPressBrightness:(UIView *)view;

/**
 *  Called when the contrast button is pressed
 *
 *  @param view the view
 */
- (void)adjustmentContainerDidPressContrast:(UIView *)view;

@end