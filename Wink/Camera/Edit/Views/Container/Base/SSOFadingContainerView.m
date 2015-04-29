//
//  SSOBottomContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFadingContainerView.h"

@interface SSOFadingContainerView ()

@end

@implementation SSOFadingContainerView

#pragma mark - Animations

/**
 *  Animate the view in
 */
- (void)animateIn {
    // Fade in animation
    POPSpringAnimation *viewAnimationFadeIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    viewAnimationFadeIn.toValue = [NSNumber numberWithFloat:1.0f];

    // Zoom in animation
    POPSpringAnimation *viewAnimationZoomIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    viewAnimationZoomIn.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];

    // Perform animations
    [self pop_addAnimation:viewAnimationFadeIn forKey:@"fadeIn"];
    [self pop_addAnimation:viewAnimationZoomIn forKey:@"zoomIn"];
}

/**
 *  Animate the view out
 */
- (void)animateOut {
    // Fade out animation
    POPSpringAnimation *viewAnimationFadeOut = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    viewAnimationFadeOut.toValue = [NSNumber numberWithFloat:0.0f];

    // Zoom out animation
    POPSpringAnimation *viewAnimationZoomOut = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    viewAnimationZoomOut.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    // Perform animations
    [self pop_addAnimation:viewAnimationFadeOut forKey:@"fadeOut"];
    [self pop_addAnimation:viewAnimationZoomOut forKey:@"zoomOut"];
}

#pragma mark - SSOAnimatableView

- (void)displayView:(BOOL)animated {
    if (animated) {
        [self animateIn];
    } else {
        self.alpha = 1.0f;
    }
}

- (void)hideView:(BOOL)animated {
    if (animated) {
        [self animateOut];
    } else {
        self.alpha = 0.0f;
    }
}

@end
