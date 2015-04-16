//
//  SSOAdjustSliderContainerView.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSOAdjustmentSliderContainerView : UIView

@property(strong, nonatomic) UISlider *slider;

/**
 *  Set the slider value
 *
 *  @param value the value
 */
- (void)setSliderValue:(float)value;

@end
