//
//  SSOMediaEditStateDraw.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateDrawColor.h"

@implementation SSOMediaEditStateDrawColor

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumDrawColor];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)drawButtonTouched {

    self.editMediaVC.drawContainerView.hidden = NO;
    self.editMediaVC.colorPickerView.colors = self.editMediaVC.colorPickerColors;
    self.editMediaVC.drawView.userInteractionEnabled = YES;
    self.editMediaVC.drawUndoButton.enabled = ([self.editMediaVC.drawView canUndo]);
    self.editMediaVC.drawView.lineColor = self.editMediaVC.colorPickerView.color;
    self.editMediaVC.drawButton.tintColor = self.editMediaVC.colorPickerView.color;
    self.editMediaVC.drawButton.alpha = 1.0f;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;

    self.editMediaVC.brightnessContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;

    self.editMediaVC.cropContainerView.hidden = YES;
    self.editMediaVC.imageCropperContainerView.hidden = YES;
    self.editMediaVC.cropButton.alpha = 0.5f;
}

@end
