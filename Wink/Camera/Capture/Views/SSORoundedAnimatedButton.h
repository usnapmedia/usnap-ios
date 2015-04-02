//
//  SSORoundedAnimatedButton.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSORoundedAnimatedButtonProtocol;

@interface SSORoundedAnimatedButton : UIButton

// Color of the circle
@property (nonatomic, strong) UIColor* circleColor;
// Opacity of the circle
@property (nonatomic) float circleOpacity;
// Thickness of the circle
@property (nonatomic) float circleLineWidth;
// Duration of the animation
@property (nonatomic) float animationDuration;
// Minimum time before the animation start
@property (nonatomic) float minimumPressDuration;

@property (nonatomic, weak) id<SSORoundedAnimatedButtonProtocol> delegate;

@end

@protocol SSORoundedAnimatedButtonProtocol

- (void)didStartAnimation:(SSORoundedAnimatedButton *)button;

- (void)didFinishAnimation:(SSORoundedAnimatedButton *)button;


@end

