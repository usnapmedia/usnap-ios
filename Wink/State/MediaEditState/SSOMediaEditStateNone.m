//
//  SSOMediaEditStateNone.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateNone.h"

@implementation SSOMediaEditStateNone

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumNone];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)drawButtonTouched {
    [self resetButtonsState];
}

- (void)textButtonTouched {
    [self resetButtonsState];
}

- (void)brightnessButtonTouched {
    [self resetButtonsState];
}

- (void)cropButtonTouched {
    [self resetButtonsState];
}

#pragma mark - UI

- (void)resetButtonsState {
    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawContainerView.hidden = YES;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 1.0f;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 1.0f;

    self.editMediaVC.brightnessContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 1.0f;

    self.editMediaVC.cropContainerView.hidden = YES;
    self.editMediaVC.imageCropperContainerView.hidden = YES;
    self.editMediaVC.cropButton.alpha = 1.0f;
}

@end
