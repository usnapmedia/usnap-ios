//
//  SSOMediaEditStateDraw.m
//
//
//  Created by Nicolas Vincensini on 2015-03-17.
//
//

#import "SSOMediaEditStateDraw.h"
#import "SSOColorPickerContainerView.h"

@interface SSOMediaEditStateDraw () <SSOColorPickerContainerViewDelegate>

@end

@implementation SSOMediaEditStateDraw

#pragma mark - SSOMediaEditStateProtocol

- (void)drawButtonTouched {

    // Setup the draw view
    self.editMediaVC.drawView.delegate = self;
    self.editMediaVC.drawView.userInteractionEnabled = YES;
    self.editMediaVC.drawButton.alpha = 1.0f;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;

    self.editMediaVC.brightnessButton.alpha = 0.5f;

    self.editMediaVC.cropButton.alpha = 0.5f;

//    self.editMediaVC.editAccessoriesContainerView.hidden = NO;
}

#pragma mark - SSOColorPickerContainerViewDelegate

- (void)colorPickerDidReset:(SSOColorPickerContainerView *)colorPickerContainerView {
    [self.editMediaVC.drawView undoLatestStep];
}

- (void)colorPickerDidChangeColor:(SSOColorPickerContainerView *)colorPickerContainerView withColor:(UIColor *)color {
    self.editMediaVC.drawView.lineColor = color;
    self.editMediaVC.drawButton.tintColor = color;
}

@end
