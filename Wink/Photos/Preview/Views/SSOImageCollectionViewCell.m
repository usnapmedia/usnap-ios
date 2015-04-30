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
#import <Masonry.h>

@interface SSOImageCollectionViewCell ()

@property(strong, nonatomic) SSOSnap *data;

@end

@implementation SSOImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.imageView setClipsToBounds:YES];
    }

    return self;
}

- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOSnap class]], @"Celldata has to be of SSOSnap type");

    if ([cellData isKindOfClass:[SSOSnap class]]) {
        self.data = (SSOSnap *)cellData;

        if ([self.data.fbLikes integerValue] >= 1) {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
              make.width.height.equalTo(@106);
            }];
        } else {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
              make.width.height.equalTo(@53);
            }];
        }

        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.data.url]];

        NSLog(@" %@", NSStringFromCGRect(self.imageView.frame));
    }
}

@end
