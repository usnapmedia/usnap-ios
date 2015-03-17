//
//  SSOMediaEditStateCrop.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateCrop.h"

@implementation SSOMediaEditStateCrop

-(void)cropButtonTouched {
    
    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawContainerView.hidden = YES;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;
    
    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;
    
    self.editMediaVC.brightnessContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;
    
    self.editMediaVC.cropContainerView.hidden = NO;
    self.editMediaVC.imageCropperView.image = (self.editMediaVC.modifiedImageView.image) ? self.editMediaVC.modifiedImageView.image : self.editMediaVC.imageView.image;
    self.editMediaVC.imageCropperContainerView.hidden = NO;
    self.editMediaVC.cropButton.alpha = 1.0f;
}

@end
