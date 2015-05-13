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
#import "SSOScreenSizeHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

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
@property(weak, nonatomic) IBOutlet UIView *imagePlaceView;

@end

@implementation SSOCampaignDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Initialization

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    // Setting the contest rule button style
    self.contestRulesButton.layer.borderWidth = 1;
    self.contestRulesButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    // Setting the font of the title
    self.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:20];
    // Setting the date label font and color
    self.dateLabel.font = [SSOThemeHelper avenirLightFontWithSize:16];
    self.dateLabel.textColor = [SSOThemeHelper firstColor];
    // Setting the campaign description label font and color
    self.descriptionLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
    self.descriptionLabel.textColor = [UIColor grayColor];
    // Setting the Prize title label and color
    self.prizeLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:16];
    self.prizeLabel.textColor = [UIColor grayColor];
    // Setting the prize description label font and color
    self.prizeDescriptionLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
    self.prizeDescriptionLabel.textColor = [UIColor grayColor];
    // Making the image the right height for the current witdh
    [self.imagePlaceView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.equalTo([NSNumber numberWithFloat:[SSOScreenSizeHelper campaignViewControllerHeightConstraint]]);
    }];
}

/**
 *  Setting Labels and buttons texts
 */

- (void)setLabels {
    // Adding NSLocalizedStrings to the static labels
    [self.contestRulesButton setTitle:NSLocalizedString(@"contest.details.contest-rules.button", nil) forState:UIControlStateNormal];
    self.prizeLabel.text = NSLocalizedString(@"contest.details.prize.label", nil);
}

#pragma mark - Data

/**
 *  Setting the text and the image to be displayed
 */
- (void)initializeData {
    // Getting the date from the back-end
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:self.campaign.startDate];
    NSDate *endDate = [formatter dateFromString:self.campaign.endDate];
    // Creating the format that the date will be displayed
    NSDateFormatter *displayFormat = [[NSDateFormatter alloc] init];
    [displayFormat setDateFormat:@"dd MMM"];
    // Setting labels
    self.descriptionLabel.text = self.campaign.descriptionCampaign;
    self.dateLabel.text = [NSString
        stringWithFormat:@"%@ - %@", [[displayFormat stringFromDate:startDate] capitalizedString], [[displayFormat stringFromDate:endDate] capitalizedString]];
    self.titleLabel.text = self.campaign.name;
    self.prizeDescriptionLabel.text = self.campaign.prize;
    // Displaying the image
    [self.activityIndicator startAnimating];
    [self.campaignImageView sd_setImageWithURL:[NSURL URLWithString:self.campaign.bannerImgUrl]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       [self.activityIndicator stopAnimating];
                                     }];
}

#pragma mark - IBActions

/**
 *  Back Action
 *
 *  @param sender button
 */

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
