//
//  SSOAlignedButtonsView.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-19.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAlignedButtonsView.h"
#import <Masonry.h>

@interface SSOAlignedButtonsView ()

//@property(nonatomic) CGSize sizeOfView;
@property(strong, nonatomic) NSArray *arrayButtons;

@end

@implementation SSOAlignedButtonsView

- (instancetype)initWithArrayButtons:(NSArray *)array andOrientation:(UIDeviceOrientation)orientation {

    if (self = [super init]) {

       // [self setupViewforOrientation:orientation];
    }

    return self;
}

- (void)setupViewforOrientation:(UIDeviceOrientation)orientation withArrayButtons:(NSArray *)arrayButtons{
    self.arrayButtons = arrayButtons;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown ||
        orientation == UIDeviceOrientationFaceDown) {
        [self addButtonsToViewPortraitMode];
    } else {
        [self addButtonsToViewLandscapeMode];
    }
}

- (void)addButtonsToViewLandscapeMode {

    if (self.arrayButtons) {

        int buttonNumber = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];

        for (UIView *view in self.arrayButtons) {
            if ([view isKindOfClass:[UIButton class]]) {

                // Increment the buttonNumber in order to do maths later
                buttonNumber++;
                button = (UIButton *)view;

                // Calcul for y constant position : buttonNumber/self.arrayButtons.count+1

                // Number of buttons in the array
                long numberItems = self.arrayButtons.count + 1;
                // Calculate the ratio
                float ratio = ((float)buttonNumber / numberItems);
                // Get the height of the view
                float viewHeight = self.frame.size.height;

                // Place the button on the view with the good ratio
                float topPadding = viewHeight * ratio;

                UIEdgeInsets padding = UIEdgeInsetsMake(topPadding, 5, 0, 5);

                [self addSubview:button];

                [button mas_remakeConstraints:^(MASConstraintMaker *make) {

                  make.centerX.equalTo(self.mas_centerX);
                  make.leading.equalTo(self.mas_leading).with.offset(padding.left);
                  make.trailing.equalTo(self.mas_trailing).with.offset(-padding.right);
                  make.centerY.equalTo(self.mas_top).with.offset(padding.top);
                }];
            }
        }
    }
}

- (void)addButtonsToViewPortraitMode {

    for (UIView *buttonview in self.subviews) {
        if ([buttonview isKindOfClass:[UIButton class]]) {
            [buttonview removeFromSuperview];
        }
    }

    if (self.arrayButtons) {

        int buttonNumber = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];

        for (UIView *view in self.arrayButtons) {
            if ([view isKindOfClass:[UIButton class]]) {

                // Increment the buttonNumber in order to do maths later
                buttonNumber++;
                button = (UIButton *)view;

                // Calcul for y constant position : buttonNumber/self.arrayButtons.count+1

                // Number of buttons in the array
                long numberItems = self.arrayButtons.count + 1;
                // Calculate the ratio
                float ratio = ((float)buttonNumber / numberItems);
                // Get the height of the view
                float viewWidth = self.frame.size.width;
//                NSLog(@" %f", viewWidth);

                // Place the button on the view with the good ratio
                float leftPadding = viewWidth * ratio;

                UIEdgeInsets padding = UIEdgeInsetsMake(5, leftPadding, 5, 0);

                [self addSubview:button];

                [button mas_remakeConstraints:^(MASConstraintMaker *make) {

                  make.centerY.equalTo(self.mas_centerY);
                  make.centerX.equalTo(self.mas_leading).with.offset(padding.left);
                  make.top.equalTo(self.mas_top).with.offset(padding.top);
                  make.bottom.equalTo(self.mas_bottom).with.offset(-padding.bottom);
                }];
            }
        }
    }
}

@end
