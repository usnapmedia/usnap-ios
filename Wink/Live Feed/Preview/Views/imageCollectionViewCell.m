//
//  imageCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Nicolas Vincensini. All rights reserved.
//

#import "imageCollectionViewCell.h"

@implementation imageCollectionViewCell

-(void)configureCell:(id)cellData {
    
    if ([cellData isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)cellData;
        self.imageView.image = image;
    }
    
}

@end
