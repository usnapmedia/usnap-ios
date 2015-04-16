//
//  SSOAdjustAccessoryContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAdjustmentAccessoryContainerView.h"

@implementation SSOAdjustmentAccessoryContainerView

#pragma mark - IBAction

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate containerViewDoneButtonPressed:self];
}

- (IBAction)brightnessButtonPressed:(id)sender {
    [self.delegate adjustmentContainerDidPressBrightness:self];
}

- (IBAction)contrastButtonPressed:(id)sender {
    [self.delegate adjustmentContainerDidPressContrast:self];
}

@end
