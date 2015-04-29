//
//  SSOProfileViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-28.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOProfileViewController.h"
#import "SSOThemeHelper.h"
#import "SSOCampaignViewController.h"
#import "WKWinkConnect.h"
#import <Masonry.h>
#import "SSOCountableItems.h"

@interface SSOProfileViewController ()

@property(weak, nonatomic) IBOutlet UIView *userAvatarView;
@property(weak, nonatomic) IBOutlet UILabel *userFirstLetterLabel;
@property(weak, nonatomic) IBOutlet UIButton *settingsButton;
@property(weak, nonatomic) IBOutlet UILabel *numberSharesLabel;
@property(weak, nonatomic) IBOutlet UILabel *sharesLabel;
@property(weak, nonatomic) IBOutlet UILabel *numberScoreLabel;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *contestsButton;
@property(weak, nonatomic) IBOutlet UIButton *myFeedButton;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet UIView *customNavBar;

@property(nonatomic) BOOL isContestsVisible;
@property(strong, nonatomic) SSOCampaignViewController *campaignVC;

@end

@implementation SSOProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self setChildVC];
    [self loadCampaigns];
}

#pragma mark - Initialization

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    self.userAvatarView.layer.cornerRadius = 5;
    self.userAvatarView.layer.masksToBounds = YES;
    self.userAvatarView.backgroundColor = [SSOThemeHelper firstColor];
    self.settingsButton.layer.cornerRadius = 5;
    self.settingsButton.layer.masksToBounds = YES;
    self.settingsButton.layer.borderWidth = 1;
    self.settingsButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.settingsButton.backgroundColor = [SSOThemeHelper secondColor];
    self.numberSharesLabel.textColor = [SSOThemeHelper firstColor];
    self.numberSharesLabel.textColor = [SSOThemeHelper firstColor];
    self.isContestsVisible = YES;
    self.contestsButton.backgroundColor = [SSOThemeHelper firstColor];
    //@FIXME
    self.customNavBar.backgroundColor = [UIColor blackColor];
}

- (void)setChildVC {
    // Set child VC
    SSOCampaignViewController *containerVC = [SSOCampaignViewController new];
    self.campaignVC = containerVC;
    // Add the child vc
    [self addChildViewController:containerVC];
    // Set the frame
    containerVC.view.frame = self.containerView.frame;
    //
    [self.containerView addSubview:containerVC.view];
    [containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.containerView);
    }];
    // Call delegate
    [containerVC didMoveToParentViewController:self];
}

- (void)loadCampaigns {
    [WKWinkConnect getCampaignsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOCampaign class]];
      // self.campaingTopVCContainer = [[SSOCampaignTopViewControllerContainer alloc] initWithArrayOfCampaigns:items.response];
      [self.campaignVC setCampaignData:items.response];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

#pragma mark - IBActions

- (IBAction)contestsButtonAction:(UIButton *)sender {
    if (!self.isContestsVisible) {
        [self changeButtonColor];
    }
}

/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 */

- (IBAction)myFeedButtonAction:(UIButton *)sender {
    if (self.isContestsVisible) {
        [self changeButtonColor];
    }
}

#pragma mark - UI

- (void)changeButtonColor {
    if (self.isContestsVisible) {
        self.isContestsVisible = NO;
        [self.contestsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.contestsButton setBackgroundColor:[SSOThemeHelper secondColor]];
        [self.myFeedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.myFeedButton setBackgroundColor:[SSOThemeHelper firstColor]];
    } else {
        self.isContestsVisible = YES;
        [self.myFeedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.myFeedButton setBackgroundColor:[SSOThemeHelper secondColor]];
        [self.contestsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contestsButton setBackgroundColor:[SSOThemeHelper firstColor]];
    }
}

@end
