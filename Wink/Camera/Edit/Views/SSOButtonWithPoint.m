//
//  SSOButtonWithPoint.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-05-04.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOButtonWithPoint.h"

@implementation SSOButtonWithPoint

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetRGBFillColor(ctx, 0, 0, 1.0, 1.0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1.0);
    CGRect circlePoint = CGRectMake((self.bounds.size.width - 10)/2, 0, 5.0, 5.0);
    
    CGContextFillEllipseInRect(ctx, circlePoint);
//    
//    CALayer *topBorder = [CALayer layer];
//    topBorder.borderColor = [UIColor redColor].CGColor;
//    topBorder.backgroundColor = [UIColor blackColor].CGColor;
//    topBorder.borderWidth = 2;
//    topBorder.frame = CGRectMake(0, 0, self.frame.size.width, 10);
//    [self.layer addSublayer:topBorder];
}

@end
