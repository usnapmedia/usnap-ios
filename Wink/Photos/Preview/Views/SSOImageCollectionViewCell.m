//
//  imageCollectionViewCell.m
//  CustomCollectionView
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Nicolas Vincensini. All rights reserved.
//

#import "SSOImageCollectionViewCell.h"
#import "SSOSnap.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SSOImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
}


- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOSnap class]], @"Celldata has to be of SSOSnap type");
    if ([cellData isKindOfClass:[SSOSnap class]]) {
        SSOSnap *data = (SSOSnap *)cellData;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.url]];
    }
}

@end
