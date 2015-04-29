//
//  SSOMyFeedCollectionViewCell.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-29.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMyFeedCollectionViewCell.h"
#import <SSBaseViewCellProtocol.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOMyFeedCollectionViewCell () <SSBaseViewCellProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SSOMyFeedCollectionViewCell 

- (void)configureCell:(id)cellData {
//TODO
}

@end