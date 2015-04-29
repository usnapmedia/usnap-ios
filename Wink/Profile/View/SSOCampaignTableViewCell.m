//
//  SSOCampaignTableViewCell.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-28.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignTableViewCell.h"
#import <SSBaseViewCellProtocol.h>
#import "SSOCampaign.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOCampaignTableViewCell () <SSBaseViewCellProtocol>

@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *numberSharesLabel;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation SSOCampaignTableViewCell

/**
 *  Fill the cell with all the information that is needed
 *
 *  @param cellData cellData
 */

- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOCampaign class]], @"Cell data has to be a SSOCampaign class");
    if ([cellData isKindOfClass:[SSOCampaign class]]) {
        SSOCampaign *campaign = cellData;
        [self.activityIndicator startAnimating];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:campaign.bannerImgUrl]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        // Activity Indicator hides itself after animatining
                                        [self.activityIndicator stopAnimating];
                                      }];
        self.titleLabel.text = campaign.name;
        self.descriptionLabel.text = campaign.descriptionCampaign;
        NSNumber *numberOfShares = [NSNumber numberWithInt:0];
        //@FIXME numberOfShares
        if ([numberOfShares integerValue] > 1) {
            self.numberSharesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"profile-page.campaign.share-label-plural", nil), @"0"];
        } else {
            self.numberSharesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"profile-page.campaign.share-label-singular", nil), @"0"];
        }
    }
}

@end
