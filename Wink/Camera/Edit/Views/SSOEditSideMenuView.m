//
//  SSOEditSideMenuView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-06.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditSideMenuView.h"

@implementation SSOEditSideMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)arrayButtons {

    if (!_arrayButtons) {
        _arrayButtons = [[NSArray alloc] initWithObjects:@"Dictionnary of button properties or button", nil];
    }

    return _arrayButtons;
}

- (void)createButtonsWithArray:(NSArray *)arrayButtons {
}

- (UIButton *)buttonText {

    if (!_buttonText) {
        _buttonText = [[UIButton alloc] init];
    }

    [_buttonText addTarget:self action:@selector(textButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonText;
}

- (UIButton *)buttonDraw {

    if (!_buttonDraw) {
        _buttonDraw = [[UIButton alloc] init];
    }

    [_buttonDraw addTarget:self action:@selector(drawButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonDraw;
}

- (UIButton *)buttonCrop {

    if (!_buttonCrop) {
        _buttonCrop = [[UIButton alloc] init];
    }

    [_buttonCrop addTarget:self action:@selector(cropButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonCrop;
}

- (UIButton *)buttonStickers {

    if (!_buttonStickers) {
        _buttonStickers = [[UIButton alloc] init];
    }

    [_buttonStickers addTarget:self action:@selector(stickersButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    return _buttonStickers;
}

- (void)textButtonSelected {
}

- (void)drawButtonSelected {
}

- (void)cropButtonSelected {
}

- (void)stickersButtonSelected {
}

@end
