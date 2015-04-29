//
//  UIImage+FixOrientation.m
//  Wink
//
//  Created by Justin Khan on 2015-03-18.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)

- (UIImage *)cropImageInContainView:(UIView *)view withLayer: (AVCaptureVideoPreviewLayer *)previewLayer
 {

    CGSize newRenderSize;

    // Set your desired output aspect ratio here. 1.0 for square, 16/9.0 for widescreen, etc.
    CGFloat desiredAspectRatio = view.bounds.size.height / view.bounds.size.width;

    CGSize naturalSize = CGSizeMake(self.size.width, self.size.height);
    CGSize adjustedSize = naturalSize;

    // Natural size of image is in landscape mode with the image rotated 90 degrees
    // Take the absolute value of the natural size and swap the height and width to get the 'true' size of the image, which is the adjustedSize
    adjustedSize.width = ABS(naturalSize.width);
    adjustedSize.height = ABS(naturalSize.height);

    // Portrait
    if (adjustedSize.width > adjustedSize.height) {
        newRenderSize = CGSizeMake(adjustedSize.height * desiredAspectRatio, adjustedSize.height);

        // Landscape
    } else {
        newRenderSize = CGSizeMake(adjustedSize.width * desiredAspectRatio, adjustedSize.width);
    }

    // Use this rect to crop the image
    
    CGRect outputRect = [previewLayer metadataOutputRectOfInterestForRect:previewLayer.bounds];

    CGRect rect = CGRectMake(0, 0, newRenderSize.width, newRenderSize.height);

    // Newly cropped image with correct size and translation
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);

    // Lastly fix the orientation of cropped image
    return [croppedImage fixOrientation];
}

/**
 *  When you take a photo using the camera, the image is rotated at least by 90 degrees
 *  Depending on the orientation of the camera, we need to change the orientation of image
 *
 *  @return Return image with proper transform
 */
- (UIImage *)fixOrientation {

    UIImageOrientation orientation = self.imageOrientation;

    if (orientation == UIImageOrientationUp)
        return self;
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (orientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI);
        break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;
    case UIImageOrientationUp:
    case UIImageOrientationUpMirrored:
        break;
    }

    switch (orientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    case UIImageOrientationUp:
    case UIImageOrientationDown:
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
        break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        // Grr...
        CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
        break;

    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
