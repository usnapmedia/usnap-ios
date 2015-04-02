//
//  SSORoundedAnimatedButton.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSORoundedAnimatedButton.h"


@interface SSORoundedAnimatedButton ()


@property (strong, nonatomic) CAShapeLayer* circle;
@property (strong, nonatomic) NSMutableArray* layersArray;

@end

@implementation SSORoundedAnimatedButton

/**
 *  Overide init method
 *
 *  @return self
 */
- (id)init
{
    self = [super init];
    if (self) {
        [self addLongTagGestureRecognizer];
        self.alpha = 0.95;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addLongTagGestureRecognizer];
        self.alpha = 0.95;
    }
    return self;
}

- (void)addLongTagGestureRecognizer
{
    UILongPressGestureRecognizer* longPress =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPress:)];
    longPress.minimumPressDuration = self.minimumPressDuration;
    [self addGestureRecognizer:longPress];
}

- (void)startAnimation
{
    
    // Set up the shape of the circle
    int radius = self.frame.size.width / 2;
    CAShapeLayer* circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path =
    [UIBezierPath
     bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0 * radius, 2.0 * radius)
     cornerRadius:radius].CGPath;
    
    // Center the cirle
    circle.position = CGPointMake(self.frame.size.width / 2 - radius,
                                  self.frame.size.height / 2 - radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    
    circle.strokeColor = self.circleColor.CGColor;
    
    circle.lineWidth = self.circleLineWidth;
    
    circle.opacity = self.circleOpacity;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    [self.layersArray addObject:circle];
    
    // Configure animation
    CABasicAnimation* drawAnimation =
    [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration = self.animationDuration;
    
    drawAnimation.repeatCount = 1.0; // Animate only once
    
    // Animate from no part of the stroke being drawn to the entire stroke being
    // drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    // the timing function is used to determine if they are change of speeds or not while the circle will be drawed
    drawAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (void)removeAnimations
{
    for (CAShapeLayer* circle in self.layersArray) {
        [circle removeFromSuperlayer];
    }
    self.layersArray = nil;

}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long Press began");
        [self startAnimation];
        [self.delegate didStartAnimation:self];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long Press");
        // [self cancelAnimation];
        [self removeAnimations];
        [self.delegate didFinishAnimation:self];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed");
    }
}

#pragma mark - Lazy instanciations

- (UIColor*)circleColor
{
    
    if (!_circleColor) {
        _circleColor = [UIColor greenColor];
    }
    return _circleColor;
}

- (float)circleLineWidth
{
    
    if (!_circleLineWidth) {
        _circleLineWidth = 5;
    }
    return _circleLineWidth;
}

- (float)circleOpacity
{
    
    if (!_circleOpacity) {
        _circleOpacity = 1;
    }
    return _circleOpacity;
}

- (NSMutableArray*)layersArray
{
    
    if (!_layersArray) {
        _layersArray = [[NSMutableArray alloc] init];
    }
    
    return _layersArray;
}

- (float)animationDuration
{
    
    if (!_animationDuration) {
        _animationDuration = 6;
    }
    
    return _animationDuration;
}

- (float)minimumPressDuration
{
    
    if (!_minimumPressDuration) {
        _minimumPressDuration = 0.5;
    }
    
    return _minimumPressDuration;
}


@end
