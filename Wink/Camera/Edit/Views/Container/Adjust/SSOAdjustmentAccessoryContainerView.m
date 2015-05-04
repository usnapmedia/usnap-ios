//
//  SSOAdjustAccessoryContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAdjustmentAccessoryContainerView.h"
#import "UIButton+VerticalLayout.h"

@interface SSOAdjustmentAccessoryContainerView ()

@property(weak, nonatomic) IBOutlet UIButton *brightnessButton;
@property(weak, nonatomic) IBOutlet UIButton *contrastButton;

@end

@implementation SSOAdjustmentAccessoryContainerView

#pragma mark - IBAction

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.brightnessButton centerVertically];
    [self.contrastButton centerVertically];
}

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
