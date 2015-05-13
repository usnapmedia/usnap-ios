//
//  SSOTopCampaignCollectionViewCell.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-24.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTopCampaignCollectionViewCell.h"
#import <SSBaseViewCellProtocol.h>
#import "SSOCampaign.h"
#import "SSOThemeHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOTopCampaignCollectionViewCell () <SSBaseViewCellProtocol>
@property(weak, nonatomic) IBOutlet UIImageView *imageViewCampaign;

@end

@implementation SSOTopCampaignCollectionViewCell

- (void)configureCell:(id)cellData {

    NSAssert([cellData isKindOfClass:[SSOCampaign class]], @"Need to pass a campaign object here");
    SSOCampaign *campaign = (SSOCampaign *)cellData;
    // Set the campaign URL object
    NSURL *imgURL = [NSURL URLWithString:campaign.bannerImgUrl];
    [self.imageViewCampaign sd_setImageWithURL:imgURL placeholderImage:nil];
    // As the imageVIew mode is "aspect fill", we need to clip the imageView to the bounds of the view (forbid it to go behind the label too)
    [self.imageViewCampaign setClipsToBounds:YES];
}

@end
