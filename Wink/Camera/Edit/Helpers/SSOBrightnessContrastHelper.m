//
//  SSOBrightnessContrastHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOBrightnessContrastHelper.h"
#import "BrightnessContrastSlidersContainerView.h"

@interface SSOBrightnessContrastHelper ()

@property(nonatomic, weak) BrightnessContrastSlidersContainerView *view;
@property(nonatomic) float lastBrightnessValue;
@property(nonatomic) float lastContrastValue;

@end

@implementation SSOBrightnessContrastHelper

#pragma mark - Setter

- (void)setView:(BrightnessContrastSlidersContainerView *)view {
    _view = view;
    [_view.brightnessSlider addTarget:self action:@selector(brightnessValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_view.contrastSlider addTarget:self action:@selector(contrastValueChanged:) forControlEvents:UIControlEventValueChanged];
    if (self.lastBrightnessValue) {
        [_view.brightnessSlider setValue:self.lastBrightnessValue];
    }
    if (self.lastContrastValue) {
        [_view.contrastSlider setValue:self.lastContrastValue];
    }
}

#pragma mark - Slider actions

/**
 *  Method called when the brigthness slider value has changed
 *
 *  @param sender the slider
 */
- (void)brightnessValueChanged:(id)sender {

    self.lastBrightnessValue = self.view.brightnessSlider.value;
    [self adjustImage];
}

/**
 *  Method called when the contrast slider value has changed
 *
 *  @param sender the slider
 */
- (void)contrastValueChanged:(id)sender {

    self.lastContrastValue = self.view.contrastSlider.value;

    [self adjustImage];
}

#pragma mark - Image editing

- (void)adjustImage {
    CGFloat brightnessValue = _view.brightnessSlider.value / _view.brightnessSlider.maximumValue;
    CGFloat contrastValue = _view.contrastSlider.value / 40.0f;

    CIContext *filterContext;

    filterContext = [CIContext contextWithOptions:nil];
    CIImage *filteredImage = [[CIImage alloc] initWithCGImage:self.imageToEdit.CGImage options:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:filteredImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:brightnessValue] forKey:kCIInputBrightnessKey];
    [filter setValue:[NSNumber numberWithFloat:contrastValue] forKey:kCIInputContrastKey];
    CIImage *outputImage = filter.outputImage;
    CGImageRef imageRef = [filterContext createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:self.imageToEdit.scale orientation:self.imageToEdit.imageOrientation];
    self.imageViewToEdit.image = newImage;
    CGImageRelease(imageRef);
}

@end