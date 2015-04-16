//
//  SSOAdjustementsHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAdjustementsHelper.h"

#define kContrastMinimumValue 0.25f
#define kContrastMaximumValue 1.75f
#define kBrightnessMinimumValue -1.0f
#define kBrightnessMaximumValue 1.0f

@interface SSOAdjustementsHelper ()

@property(nonatomic) float lastBrightnessValue;
@property(nonatomic) float lastContrastValue;

@end

@implementation SSOAdjustementsHelper

- (instancetype)init {
    if (self = [super init]) {
        // Set default value
        _lastContrastValue = 1.0f;
        _lastBrightnessValue = 0.0f;
    }
    return self;
}

#pragma mark - Getters

- (float)contrastSliderValue {
    return [self convertContrastRealValueToSliderValue];
}

- (float)brightnessSliderValue {
    return [self convertBrightnessRealValueToSliderValue];
}

#pragma mark - Setters

- (void)setContrastWithSliderValue:(float)value {
    _lastContrastValue = [self convertContrastSliderValueToRealValue:value];
}

- (void)setBrightnessWithSliderValue:(float)value {
    _lastBrightnessValue = [self convertBrightnessSliderValueToRealValue:value];
}

#pragma mark - Conversion

/**
 *  Convert the slider value to the real value for image edition
 *
 *  @param sliderValue the slider value
 *
 *  @return the real value
 */
- (float)convertContrastSliderValueToRealValue:(float)sliderValue {
    return ((sliderValue - kSliderMinimumValue) * (kContrastMaximumValue - kContrastMinimumValue)) / (kSliderMaximumValue - kSliderMinimumValue) +
           kContrastMinimumValue;
}

/**
 *  Convert the real value to the slider value
 *
 *  @return the slider value
 */
- (float)convertContrastRealValueToSliderValue {
    return ((_lastContrastValue - kContrastMinimumValue) * (kSliderMaximumValue - kSliderMinimumValue)) / (kContrastMaximumValue - kContrastMinimumValue) +
           kSliderMinimumValue;
}

/**
 *  Convert the slider value to the real value for image edition
 *
 *  @param sliderValue the slider value
 *
 *  @return the real value
 */
- (float)convertBrightnessSliderValueToRealValue:(float)sliderValue {
    return ((sliderValue - kSliderMinimumValue) * (kBrightnessMaximumValue - kBrightnessMinimumValue)) / (kSliderMaximumValue - kSliderMinimumValue) +
           kBrightnessMinimumValue;
}

/**
 *  Convert the real value to the slider value
 *
 *  @return the slider value
 */
- (float)convertBrightnessRealValueToSliderValue {
    return ((_lastBrightnessValue - kBrightnessMinimumValue) * (kSliderMaximumValue - kSliderMinimumValue)) /
               (kBrightnessMaximumValue - kBrightnessMinimumValue) +
           kSliderMinimumValue;
}

#pragma mark - Image editing

- (void)adjustImage {

    CIContext *filterContext;

    filterContext = [CIContext contextWithOptions:nil];
    CIImage *filteredImage = [[CIImage alloc] initWithCGImage:self.imageToEdit.CGImage options:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:filteredImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:_lastBrightnessValue] forKey:kCIInputBrightnessKey];
    [filter setValue:[NSNumber numberWithFloat:_lastContrastValue] forKey:kCIInputContrastKey];
    CIImage *outputImage = filter.outputImage;
    CGImageRef imageRef = [filterContext createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:self.imageToEdit.scale orientation:self.imageToEdit.imageOrientation];
    self.imageViewToEdit.image = newImage;
    CGImageRelease(imageRef);
}

@end
