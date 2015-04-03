//
//  SSOEditMediaMovableTextView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditMediaMovableTextView.h"

@interface SSOEditMediaMovableTextView () <UIGestureRecognizerDelegate>

@property(strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation SSOEditMediaMovableTextView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.center = CGPointMake(roundf([UIScreen mainScreen].bounds.size.width / 2.0f), roundf([UIScreen mainScreen].bounds.size.height / 2.0f));
        self.selectable = NO;
        self.scrollEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont winkFontAvenirWithSize:60.0f];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.75f;
        self.layer.shadowRadius = 1.0f;
        self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        self.returnKeyType = UIReturnKeyDone;

        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTextViewGesture)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];

        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapTextView)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.delegate = self;
        [self addGestureRecognizer:doubleTapGesture];
    }

    return self;
}

#pragma mark - Gestures

/**
 *  Called when the user double tap the text view
 */
- (void)doubleTapTextView {
    // Remove keyboard if shown
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
}

/**
 *  Called when the user drags the text view
 */
- (void)dragTextViewGesture {
    // Remove keyboard if shown
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
    // Drag the view
    CGPoint translation = [self.panGesture translationInView:self.superview];
    self.panGesture.view.center = CGPointMake(self.panGesture.view.center.x + translation.x, self.panGesture.view.center.y + translation.y);
    [self.panGesture setTranslation:CGPointMake(0, 0) inView:self.superview];
}

/**
 *  @OVERRIDE
 *  Allow multiple gestures on the view
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
