//
//  SSOMediaEditStateBrightness.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateBrightness.h"

@implementation SSOMediaEditStateBrightness

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumBrightness];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)brightnessButtonTouched {

    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;
    self.editMediaVC.colorPickerContainerView.hidden = YES;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.textButton.alpha = 0.5f;

    self.editMediaVC.brightnessButton.alpha = 1.0f;

    self.editMediaVC.cropButton.alpha = 0.5f;
    self.editMediaVC.cropButton.tintColor = [UIColor whiteColor];

    self.editMediaVC.brightnessContrastContainerView.hidden = NO;
    self.editMediaVC.editAccessoriesContainerView.hidden = NO;
}

@end