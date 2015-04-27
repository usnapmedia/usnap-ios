//
//  SSOTopPhotosCollectionViewCell.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTopPhotosCollectionViewCell.h"
#import "SSOSnap.h"
#import <SSBaseViewCellProtocol.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOTopPhotosCollectionViewCell () <SSBaseViewCellProtocol>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end

@implementation SSOTopPhotosCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - SSBaseViewCellProtocol

- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOSnap class]], @"Cell data has to be of SSOSnap class");
    if ([cellData isKindOfClass:[SSOSnap class]]) {
        SSOSnap *snap = (SSOSnap *)cellData;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:snap.url]];
        [self.nameLabel setText:snap.email];
        //@TODO Set the pts
    }
}

@end
