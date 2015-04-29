//
//  UIImage+FixOrientation.h
//  Wink
//
//  Created by Justin Khan on 2015-03-18.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

/**
 *  Crop image based on the containing view
 *
 *  @param image Image to be cropped
 *  @param view  Container view
 *
 *  @return Cropped image
 */
- (UIImage *)cropImageInContainView:(UIView *)view withLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

- (UIImage *)fixOrientation;
@end
