//
//  BrightnessContrastSlidersView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "BrightnessContrastSlidersContainerView.h"

@interface BrightnessContrastSlidersContainerView ()
@property(weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property(weak, nonatomic) IBOutlet UILabel *contrastLabel;

@end

@implementation BrightnessContrastSlidersContainerView

- (void)awakeFromNib {

    [super awakeFromNib];
    // Set the UI
    [self setLabels];
    [self setSliders];
}

#pragma mark - UI

/**
 *  Set the labels
 */
- (void)setLabels {

    self.brightnessLabel.text = NSLocalizedString(@"brightness", @"");
    self.brightnessLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.brightnessLabel.layer.shadowOpacity = 0.75f;
    self.brightnessLabel.layer.shadowRadius = 1.0f;
    self.brightnessLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    self.contrastLabel.text = NSLocalizedString(@"contrast", @"");
    self.contrastLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contrastLabel.layer.shadowOpacity = 0.75f;
    self.contrastLabel.layer.shadowRadius = 1.0f;
    self.contrastLabel.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

/**
 *  Set the sliders
 */
- (void)setSliders {
    [self.brightnessSlider setThumbImage:[UIImage imageNamed:@"sliderCircle.png"] forState:UIControlStateNormal];
    [self.brightnessSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderBar.png"] forState:UIControlStateNormal];
    [self.brightnessSlider setMaximumTrackImage:[UIImage imageNamed:@"sliderBar.png"] forState:UIControlStateNormal];
    self.brightnessSlider.minimumValue = -100; // -1
    self.brightnessSlider.maximumValue = 100;  // +1
    self.brightnessSlider.value = 0;

    [self.contrastSlider setThumbImage:[UIImage imageNamed:@"sliderCircle.png"] forState:UIControlStateNormal];
    [self.contrastSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderBar.png"] forState:UIControlStateNormal];
    [self.contrastSlider setMaximumTrackImage:[UIImage imageNamed:@"sliderBar.png"] forState:UIControlStateNormal];
    self.contrastSlider.minimumValue = 10.0f; // 0.25f;
    self.contrastSlider.maximumValue = 70.0f; // To get it to be in the middle we make it 1.75 (real = 4);
    self.contrastSlider.value = 40.0f;
}

@end
