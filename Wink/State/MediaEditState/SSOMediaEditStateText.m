//
//  SSOMediaEditStateText.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateText.h"

@implementation SSOMediaEditStateText

#pragma mark - Initialization

-(instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumText];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

-(void)textButtonTouched {
    
    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawContainerView.hidden = YES;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;
    
    self.editMediaVC.textView.editable = YES;
    self.editMediaVC.textView.userInteractionEnabled = YES;
    [self.editMediaVC.textView becomeFirstResponder];
    self.editMediaVC.textButton.alpha = 1.0f;
    
    self.editMediaVC.brightnessContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;
    
    self.editMediaVC.cropContainerView.hidden = YES;
    self.editMediaVC.imageCropperContainerView.hidden = YES;
    self.editMediaVC.cropButton.alpha = 0.5f;
}

@end
