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
    self.editMediaVC.drawContainerView.hidden = YES;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;

    self.editMediaVC.editAccessoriesContainerView.hidden = NO;
    self.editMediaVC.brightnessButton.alpha = 1.0f;

    self.editMediaVC.cropContainerView.hidden = YES;
    self.editMediaVC.imageCropperContainerView.hidden = YES;
    self.editMediaVC.cropButton.alpha = 0.5f;
    
    [self initBrightnessAndContrastUI];
}

- (void)initBrightnessAndContrastUI {
    if (!self.editMediaVC.brightnessContrastHelper)
    self.editMediaVC.brightnessContrastHelper = [[SSOBrightnessContrastHelper alloc] init];
    
    self.editMediaVC.brightnessContrastHelper.imageViewToEdit = self.editMediaVC.imageView;
    self.editMediaVC.brightnessContrastHelper.imageToEdit = self.editMediaVC.image;
    
    self.editMediaVC.editAccessoriesContainerView.backgroundColor = [UIColor clearColor];
    BrightnessContrastSlidersView *containerView = [NSBundle loadBrightnessContrastSliderView];
    // Set the view for the helper
    [self.editMediaVC.brightnessContrastHelper setView:containerView];
    
    [self.editMediaVC.editAccessoriesContainerView addSubview:containerView];
    // Set the container inside the view to have constraints on the edges
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.editMediaVC.editAccessoriesContainerView);
    }];
}


@end
