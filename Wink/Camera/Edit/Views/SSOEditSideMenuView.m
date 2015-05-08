//
//  SSOEditSideMenuView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-06.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditSideMenuView.h"
#import <Masonry.h>
#import "SSOOrientationHelper.h"

@interface SSOEditSideMenuView ()
@property(nonatomic) CGSize sizeOfView;
@property(nonatomic, strong) UIVisualEffectView *effectView;

@property(strong, nonatomic) UIButton *buttonText;
@property(strong, nonatomic) UIButton *buttonDraw;
@property(strong, nonatomic) UIButton *buttonCrop;
@property(strong, nonatomic) UIButton *buttonStickers;

@end

@implementation SSOEditSideMenuView

- (void)setSizeOfView:(CGSize)sizeOfView {

    _sizeOfView = sizeOfView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if ((self = [super initWithCoder:aDecoder])) {

        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self setupUI];
}

- (void)setupUI {

    if (self.sizeOfView.height == 0) {
        self.sizeOfView = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }
    [self addViewWithBlur];
    UIDeviceOrientation deviceOrientation = [[SSOOrientationHelper sharedInstance] orientation];
    if (deviceOrientation == UIDeviceOrientationFaceUp || deviceOrientation == UIDeviceOrientationPortrait ||
        deviceOrientation == UIDeviceOrientationPortraitUpsideDown || deviceOrientation == UIDeviceOrientationFaceDown ||
        deviceOrientation == UIDeviceOrientationUnknown) {
        [self addButtonsToViewPortraitMode];
    }
    //    } else {
    //        [self addButtonsToViewLandscapeMode];
    //    }
}

/**
 *  Add the blur view
 */
- (void)addViewWithBlur {

    // Only add the view if the effect was never applied
    if (!self.effectView) {

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sizeOfView.width, self.sizeOfView.height)];
        view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3f];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        // create blur effect
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

        // add blur to an effect view
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        NSLog(@"frame %f", self.frame.size.height);

        self.effectView.frame = CGRectMake(0, 0, self.sizeOfView.width, self.sizeOfView.height);

        [self.effectView.contentView addSubview:view];

        // add both effect views to the image view
        [self addSubview:self.effectView];
        //[self addSubview:vibrantView];

        [self.effectView mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self);
        }];
    }
}

/**
 *  Display the buttons on the view when the phone is in landscape mode
 */
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
                float viewHeight = self.effectView.frame.size.height;
                NSLog(@"effectView %f   viewWidht %f", viewHeight, self.sizeOfView.height);

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

/**
 *  Display the buttons on the view when the phone is in portrait mode
 */
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
                float viewWidth = self.sizeOfView.width;
                NSLog(@" %f", viewWidth);

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

#pragma mark - Lazy instanciations

- (NSArray *)arrayButtons {

    if (!_arrayButtons) {
        _arrayButtons = [[NSArray alloc] initWithObjects:self.buttonText, self.buttonDraw, self.buttonCrop, self.buttonStickers, nil];
    }

    return _arrayButtons;
}

- (void)createButtonsWithArray:(NSArray *)arrayButtons {
}

- (UIButton *)buttonText {

    if (!_buttonText) {
        _buttonText = [[UIButton alloc] init];
        [_buttonText setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    }

    // [_buttonText addTarget:self action:@selector(textButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonText;
}

- (UIButton *)buttonDraw {

    if (!_buttonDraw) {
        _buttonDraw = [[UIButton alloc] init];
        [_buttonDraw setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    }

    // [_buttonDraw addTarget:self action:@selector(drawButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonDraw;
}

- (UIButton *)buttonCrop {

    if (!_buttonCrop) {
        _buttonCrop = [[UIButton alloc] init];
        [_buttonCrop setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    }

    //    [_buttonCrop addTarget:self action:@selector(cropButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonCrop;
}

- (UIButton *)buttonStickers {

    if (!_buttonStickers) {
        _buttonStickers = [[UIButton alloc] init];
        [_buttonStickers setImage:[UIImage imageNamed:@"mediaButtonIcon"] forState:UIControlStateNormal];
    }

    //[_buttonStickers addTarget:self action:@selector(stickersButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonStickers;
}

@end
