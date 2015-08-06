//
//  SSOMyFeedCollectionViewCell.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-29.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMyFeedCollectionViewCell.h"
#import "SSBaseViewCellProtocol.h"
#import "SSOSnap.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOMyFeedCollectionViewCell () <SSBaseViewCellProtocol>

@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SSOMyFeedCollectionViewCell

/**
 *  Fill the cell with all the information needed
 *
 *  @param cellData cellData
 */

- (void)configureCell:(id)cellData {
}


- (void)willDisplayCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOSnap class]], @"Cell data has to be a SSOSnap class");
    if ([cellData isKindOfClass:[SSOSnap class]]) {
        SSOSnap *snap = cellData;
        [self.activityIndicator startAnimating];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[snap thumbUrl:self.frame.size.width height:self.frame.size.height]]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          [self.activityIndicator stopAnimating];
                                      }];
    }
}
@end