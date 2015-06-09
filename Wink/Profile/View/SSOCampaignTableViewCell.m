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
#import "SSOThemeHelper.h"
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
        self.numberSharesLabel.textColor = [SSOThemeHelper firstColor];
        self.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:18];
        self.numberSharesLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
        self.descriptionLabel.font = [SSOThemeHelper avenirLightFontWithSize:13];
        SSOCampaign *campaign = cellData;
        [self.activityIndicator startAnimating];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:campaign.bannerImgUrl]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        // Activity Indicator hides itself after animatining
                                        [self.activityIndicator stopAnimating];
                                      }];
        self.titleLabel.text = campaign.name;
        self.descriptionLabel.text = campaign.prize;
        NSNumber *numberOfShares = [NSNumber numberWithInt:0];
        //@FIXME numberOfShares
        if ([numberOfShares integerValue] > 1) {
            self.numberSharesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"profile-page.campaign.share-label-plural", nil), numberOfShares];
        } else {
            self.numberSharesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"profile-page.campaign.share-label-singular", nil), numberOfShares];
        }
    }
}

@end
