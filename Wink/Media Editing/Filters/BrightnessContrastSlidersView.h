//
//  BrightnessContrastSlidersView.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrightnessContrastSlidersView : UIView

@property(weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property(weak, nonatomic) IBOutlet UISlider *contrastSlider;

@end
