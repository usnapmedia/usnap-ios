//
//  UIImage+FixOrientation.h
//  Wink
//
//  Created by Justin Khan on 2015-03-18.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)

- (UIImage *)fixOrientation;
- (UIImage *)fixOrientationWithOriginalOrientation:(UIImageOrientation)orientation;

@end
