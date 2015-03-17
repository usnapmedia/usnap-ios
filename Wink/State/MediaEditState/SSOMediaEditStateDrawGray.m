//
//  SSOMediaEditStateDrawGrey.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateDrawGray.h"

@implementation SSOMediaEditStateDrawGray

#pragma mark - Initialization

-(instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumDrawGray];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

-(void)drawButtonTouched {
    
    
    self.editMediaVC.drawContainerView.hidden = NO;
    self.editMediaVC.colorPickerView.colors = self.editMediaVC.colorPickerGrayscaleColors;
    self.editMediaVC.drawView.userInteractionEnabled = YES;
    self.editMediaVC.drawUndoButton.enabled = ([self.editMediaVC.drawView canUndo]);
    self.editMediaVC.drawView.lineColor = self.editMediaVC.colorPickerView.color;
    self.editMediaVC.drawButton.tintColor = self.editMediaVC.colorPickerView.color;
    self.editMediaVC.drawButton.alpha = 1.0f;
    
    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;
    
    self.editMediaVC.editAccessoriesContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;
    
    self.editMediaVC.cropContainerView.hidden = YES;
    self.editMediaVC.imageCropperContainerView.hidden = YES;
    self.editMediaVC.cropButton.alpha = 0.5f;
}

@end
