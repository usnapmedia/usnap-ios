//
//  WKColorPickerView.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-08.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKColorPickerView.h"

@interface WKColorPickerView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation WKColorPickerView

#pragma mark - Initializer

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _color = [UIColor redColor];
        [self setupUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        _color = [UIColor redColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - Set the colors

- (void)setColors:(NSArray *)colors {
    if (_colors != colors) {
        _colors = colors;
        
        [self setNeedsLayout];
    }
}

#pragma mark - Setup & Update UI

- (void)setupUI {
    
    // Setup the view
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 2.0f;
    
    // Setup the gradient layer
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)updateUI {
    
    // Create array of CGColor objects
    NSMutableArray *colors = [NSMutableArray array];
    for (UIColor *color in self.colors) {
        [colors addObject:(id)color.CGColor];
    }
    
    // Setup the gradient
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
    self.gradientLayer.colors = colors;
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint([self touchFrame], point)) {
        self.color = [self colorAtPoint:CGPointMake(point.x, roundf(self.bounds.size.height/2.0f))];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint([self touchFrame], point)) {
        self.color = [self colorAtPoint:CGPointMake(point.x, roundf(self.bounds.size.height/2.0f))];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint([self touchFrame], point)) {
        self.color = [self colorAtPoint:CGPointMake(point.x, roundf(self.bounds.size.height/2.0f))];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Hit Testing

- (CGRect)touchFrame {
    CGFloat margin = 10.0f;
    CGRect touchFrame = CGRectMake(self.bounds.origin.x - margin, self.bounds.origin.y - margin, self.bounds.size.width + (margin * 2), self.bounds.size.height + (margin * 2));
    return touchFrame;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = NO;
    if (CGRectContainsPoint([self touchFrame], point)) {
        result = YES;
    }
    return result;
}

#pragma mark - Layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Update the UI
    [self updateUI];
}

@end
