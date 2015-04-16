//
//  SSOSlidingContainerView.m
//
//
//  Created by Gabriel Cartier on 2015-04-08.
//
//

#import "SSOSlidingContainerView.h"
#import <pop/POP.h>

@implementation SSOSlidingContainerView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeAnimations];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeAnimations];
    }
    return self;
}

#pragma mark - Animations

/**
 *  Initialize animations variables
 *  @NOTE: This method needs to be overriden
 */
- (void)initializeAnimations {
}

/**
 *  Animate the view in
 */
- (void)animateIn {
    // Fade in animation
    POPSpringAnimation *viewAnimationFadeIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    viewAnimationFadeIn.toValue = [NSNumber numberWithFloat:1.0f];

    // Slide in animation
    POPSpringAnimation *viewAnimationSlideIn = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    viewAnimationSlideIn.toValue = [NSValue valueWithCGRect:self.viewInRect];

    // Perform animations
    [self pop_addAnimation:viewAnimationFadeIn forKey:@"fadeIn"];
    [self pop_addAnimation:viewAnimationSlideIn forKey:@"slideIn"];
}

/**
 *  Animate the view out
 */
- (void)animateOut {
    // Fade out animation
    POPSpringAnimation *viewAnimationFadeOut = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    viewAnimationFadeOut.toValue = [NSNumber numberWithFloat:0.0f];

    // Zoom in animation
    POPSpringAnimation *viewAnimationSlideOut = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    viewAnimationSlideOut.toValue = [NSValue valueWithCGRect:self.viewOutRect];

    // Perform animations
    [self pop_addAnimation:viewAnimationFadeOut forKey:@"fadeOut"];
    [self pop_addAnimation:viewAnimationSlideOut forKey:@"slideOut"];
}

#pragma mark - SSOAnimatableView

- (void)displayView:(BOOL)animated {
    if (animated) {
        [self animateIn];
    } else {
        self.frame = self.viewInRect;
    }
}

- (void)hideView:(BOOL)animated {
    if (animated) {
        [self animateOut];
    } else {
        self.frame = self.viewOutRect;
    }
}

@end
