//
//  SSOCampaignDetailViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignDetailViewController.h"
#import "SSOUSnapLightButton.h"
#import "SSOThemeHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOCampaignDetailViewController ()

@property(strong, nonatomic) SSOCampaign *campaign;

@property(weak, nonatomic) IBOutlet UIView *customNavBar;
@property(weak, nonatomic) IBOutlet SSOUSnapLightButton *contestRulesButton;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property(weak, nonatomic) IBOutlet UILabel *prizeLabel;
@property(weak, nonatomic) IBOutlet UILabel *prizeDescriptionLabel;
@property(weak, nonatomic) IBOutlet UIImageView *campaignImageView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SSOCampaignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self setLabels];
    [self initializeData];
}

- (instancetype)initWithCampaign:(SSOCampaign *)campaign {
    if (self = [super init]) {
        self.campaign = campaign;
    }
    return self;
}

- (void)initializeUI {
    self.contestRulesButton.layer.borderWidth = 1;
    self.contestRulesButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:20];
    self.dateLabel.font = [SSOThemeHelper avenirLightFontWithSize:16];
    self.dateLabel.textColor = [SSOThemeHelper firstColor];
    self.descriptionLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
    self.descriptionLabel.textColor = [UIColor grayColor];
    self.prizeLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:16];
    self.prizeLabel.textColor = [UIColor grayColor];
    self.prizeDescriptionLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
    self.prizeDescriptionLabel.textColor = [UIColor grayColor];
}

- (void)setLabels {
    [self.contestRulesButton setTitle:NSLocalizedString(@"contest.details.contest-rules.button", nil) forState:UIControlStateNormal];
    self.prizeLabel.text = NSLocalizedString(@"contest.details.prize.label", nil);
}

- (void)initializeData {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:self.campaign.startDate];
    NSDate *endDate = [formatter dateFromString:self.campaign.endDate];
    NSDateFormatter *displayFormat = [[NSDateFormatter alloc] init];
    [displayFormat setDateFormat:@"dd MMM"];

    self.descriptionLabel.text = self.campaign.descriptionCampaign;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [[displayFormat stringFromDate:startDate] capitalizedString], [[displayFormat stringFromDate:endDate] capitalizedString]];
    self.titleLabel.text = self.campaign.name;
    self.prizeDescriptionLabel.text = self.campaign.prize;
    [self.activityIndicator startAnimating];
    [self.campaignImageView sd_setImageWithURL:[NSURL URLWithString:self.campaign.bannerImgUrl]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       [self.activityIndicator stopAnimating];
                                     }];
}

- (IBAction)backButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
