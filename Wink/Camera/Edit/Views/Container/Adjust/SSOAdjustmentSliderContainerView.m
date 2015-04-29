//
//  SSOAdjustSliderContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAdjustmentSliderContainerView.h"
#import "Constants.h"
#import <Masonry.h>

#define kSliderPadding 20.0f

@implementation SSOAdjustmentSliderContainerView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

/**
 *  Initialize the UI of the slider
 */
- (void)initializeUI {
    self.slider = [UISlider new];

    // Set the UI
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderCircle.png"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"sliderBar.png"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"sliderBar.png"] forState:UIControlStateNormal];

    // Add the slider view
    [self addSubview:self.slider];

    // Add constraint with padding left and right and center in Y
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).with.offset(kSliderPadding);
      make.right.equalTo(self).with.offset(-kSliderPadding);
      make.centerY.equalTo(self);
    }];
}

#pragma mark - Setter

- (void)setSliderValue:(float)value {
    self.slider.value = value;
}

@end
