//
//  SSOBottomContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOBottomContainerView.h"

NSString *const kSSOBottomContainerViewInName = @"kSSOBottomContainerViewInName";
NSString *const kSSOBottomContainerViewOutName = @"kSSOBottomContainerViewOutName";

@implementation SSOBottomContainerView

@synthesize viewAnimationIn;
@synthesize viewAnimationOut;
@synthesize viewOutRect;
@synthesize viewInRect;

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
 */
- (void)initializeAnimations {
    // Set the color picker in and out rect
    self.viewInRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.viewOutRect = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    // Initialize navigation bar animation
    self.viewAnimationIn = [POPSpringAnimation animation];
    self.viewAnimationIn.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    self.viewAnimationIn.name = kSSOBottomContainerViewInName;
    self.viewAnimationIn.delegate = self;
    // Move the color picker up it's size + the offset
    self.viewAnimationIn.toValue = [NSValue valueWithCGRect:self.viewInRect];

    self.viewAnimationOut = [POPSpringAnimation animation];
    self.viewAnimationOut.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    self.viewAnimationOut.name = kSSOBottomContainerViewOutName;
    self.viewAnimationOut.delegate = self;

    // Move the color picker down it's size + the offset
    self.viewAnimationOut.toValue = [NSValue valueWithCGRect:self.viewOutRect];
}

#pragma mark - SSOAnimatableView

- (void)displayView:(BOOL)animated {
    if (animated) {
        [self pop_addAnimation:self.viewAnimationIn forKey:kSSOBottomContainerViewInName];
    } else {
        self.frame = self.viewInRect;
    }
}

- (void)hideView:(BOOL)animated {
    if (animated) {
        [self pop_addAnimation:self.viewAnimationOut forKey:kSSOBottomContainerViewOutName];
    } else {
        self.frame = self.viewOutRect;
    }
}

@end
