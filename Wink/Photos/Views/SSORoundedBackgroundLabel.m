//
//  SSORoundedBackgroundLabel.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSORoundedBackgroundLabel.h"

@implementation SSORoundedBackgroundLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //rect = CGRectMake(0, 0, rect.size.height, rect.size.height);
    
    [super drawRect:rect];

    CGFloat lineWidth = -2;
    CGRect borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 0, 0, 1, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextFillEllipseInRect(context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
    
    [super drawTextInRect:rect];
}

@end
