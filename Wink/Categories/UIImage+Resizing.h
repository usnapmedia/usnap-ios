//
//  UIImage+Resizing.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-02-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizing)

/**
 *  Resize an image to a specific size
 *
 *  @param size the size wanted
 *
 *  @return the new image
 */
- (UIImage *)scaleToSize:(CGSize)size;

@end
