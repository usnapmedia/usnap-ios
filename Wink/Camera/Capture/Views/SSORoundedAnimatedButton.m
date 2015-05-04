//
//  SSORoundedAnimatedButton.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSORoundedAnimatedButton.h"

@interface SSORoundedAnimatedButton ()

@property(strong, nonatomic) CAShapeLayer *circle;
@property(strong, nonatomic) NSMutableArray *layersArray;

@end

@implementation SSORoundedAnimatedButton

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addLongTagGestureRecognizer];
        self.alpha = 0.95;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    }
    return self;
}

- (void)dealloc {

    [self.layer removeAllAnimations];
}


- (void)addLongTagGestureRecognizer {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = self.minimumPressDuration;
    [self addGestureRecognizer:longPress];
}

- (void)startAnimation {

    // Set up the shape of the circle
    int radius = self.frame.size.width / 2;
    self.circle = [CAShapeLayer layer];
    // Make a circular shape
    self.circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0 * radius, 2.0 * radius) cornerRadius:radius].CGPath;

    // Center the cirle
    self.circle.position = CGPointMake(self.frame.size.width / 2 - radius, self.frame.size.height / 2 - radius);

    // Configure the apperence of the circle
    self.circle.fillColor = [UIColor clearColor].CGColor;

    self.circle.strokeColor = self.circleColor.CGColor;

    self.circle.lineWidth = self.circleLineWidth;

    self.circle.opacity = self.circleOpacity;

    // Add to parent layer
    [self.layer addSublayer:self.circle];
    [self.layersArray addObject:self.circle];

    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    drawAnimation.duration = self.animationDuration;

    drawAnimation.repeatCount = 1.0; // Animate only once

    // Animate from no part of the stroke being drawn to the entire stroke being
    // drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];

    // the timing function is used to determine if they are change of speeds or not while the circle will be drawed
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    // Add the animation to the circle
    [self.circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (void)pauseAnimation {
    CFTimeInterval pausedTime = [self.circle convertTime:CACurrentMediaTime() fromLayer:nil];
    self.circle.speed = 0.0;
    self.circle.timeOffset = pausedTime;
}

- (void)resumeAnimation {
    CFTimeInterval pausedTime = [self.circle timeOffset];
    self.circle.speed = 1.0;
    self.circle.timeOffset = 0.0;
    self.circle.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.circle convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.circle.beginTime = timeSincePause;
}

- (void)resetAnimation {
    for (CAShapeLayer *circle in self.layersArray) {
        [circle removeFromSuperlayer];
    }
    self.layersArray = nil;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long Press began");
        [self startAnimation];
        [self.delegate didStartLongPressGesture:self];
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long Press");

        [self.delegate didFinishLongPressGesture:self];
    }

    if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed");
    }
}

#pragma mark - Lazy instantiations

- (UIColor *)circleColor {

    if (!_circleColor) {
        _circleColor = [UIColor greenColor];
    }
    return _circleColor;
}

- (float)circleLineWidth {

    if (!_circleLineWidth) {
        _circleLineWidth = 5;
    }
    return _circleLineWidth;
}

- (float)circleOpacity {

    if (!_circleOpacity) {
        _circleOpacity = 1;
    }
    return _circleOpacity;
}

- (NSMutableArray *)layersArray {

    if (!_layersArray) {
        _layersArray = [[NSMutableArray alloc] init];
    }

    return _layersArray;
}

- (float)animationDuration {

    if (!_animationDuration) {
        _animationDuration = 6;
    }

    return _animationDuration;
}

- (float)minimumPressDuration {

    if (!_minimumPressDuration) {
        _minimumPressDuration = 0.5;
    }

    return _minimumPressDuration;
}

@end
