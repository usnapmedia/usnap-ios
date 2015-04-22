//
//  imageCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Nicolas Vincensini. All rights reserved.
//

#import "SSOImageCollectionViewCell.h"

@implementation SSOImageCollectionViewCell

- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[UIImage class]], @"Celldata has to be of image type");
    if ([cellData isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)cellData;
        self.imageView.image = image;
    }
}

@end
