//
//  UIView+WKAdditions.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-04.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WKAdditions)

- (UIImage *)snapshotImage;
- (UIColor *)colorAtPoint:(CGPoint)point;

@end
