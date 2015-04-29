//
//  SSOColorPickerView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOColorPickerContainerView.h"

@interface SSOColorPickerContainerView ()
@property(weak, nonatomic, readwrite) IBOutlet WKColorPickerView *colorPickerView;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation SSOColorPickerContainerView

#pragma mark - Setter

- (void)setResetButtonImage:(UIImage *)image {
    [self.resetButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - IBAction

/**
 *  Color picker view color has changed
 *
 *  @param sender the view
 */
- (IBAction)colorPickerColorChanged:(id)sender {
    [self.delegate colorPickerDidChangeColor:self withColor:self.colorPickerView.color];
}

/**
 *  Reset button has been pressed
 *
 *  @param sender the button
 */
- (IBAction)resetButtonPressed:(id)sender {
    [self.delegate colorPickerDidReset:self];
}

@end
