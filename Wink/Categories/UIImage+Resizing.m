//
//  UIImage+Resizing.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-02-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;
}

@end
