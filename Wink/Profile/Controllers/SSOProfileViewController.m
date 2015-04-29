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
#import "SSOSnap.h"
#import "SSOCountableItems.h"
#import "SSOFeedConnect.h"

#import "SSOMyFeedViewController.h"

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
@property(weak, nonatomic) IBOutlet UIView *customNavBar;
@property(weak, nonatomic) IBOutlet UIView *contestView;
@property(weak, nonatomic) IBOutlet UIView *myFeedView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *contestActivityIndicator;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *myFeedActivityIndicator;

@property(nonatomic) BOOL isContestsVisible;
@property(strong, nonatomic) SSOCampaignViewController *campaignVC;
@property(strong, nonatomic) SSOMyFeedViewController *myFeedVC;

@end

@implementation SSOProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self setChildVC];
    [self loadCampaigns];
    [self loadMyFeed];
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
    self.myFeedView.hidden = YES;
    self.contestsButton.backgroundColor = [SSOThemeHelper firstColor];
    //@FIXME
    self.customNavBar.backgroundColor = [UIColor blackColor];

    NSLog(@"%f", self.tabBarController.tabBar.frame.size.height);
}

/**
 *  Add the table view to the container
 */

- (void)setChildVC {
    // Set child VC
    SSOCampaignViewController *campaignVC = [SSOCampaignViewController new];
    self.campaignVC = campaignVC;
    // Add the child vc
    [self addChildViewController:campaignVC];
    // Set the frame
    campaignVC.view.frame = self.contestView.frame;
    //
    [self.contestView insertSubview:campaignVC.view belowSubview:self.contestActivityIndicator];
    [campaignVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contestView);
    }];
    // Call delegate
    [campaignVC didMoveToParentViewController:self];

    SSOMyFeedViewController *myFeedVC = [SSOMyFeedViewController new];
    self.myFeedVC = myFeedVC;
    // Add the child vc
    [self addChildViewController:myFeedVC];
    // Set the frame
    myFeedVC.view.frame = self.myFeedView.frame;
    //

    [self.myFeedView insertSubview:myFeedVC.view belowSubview:self.myFeedActivityIndicator];
    [myFeedVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.myFeedView);
    }];
    // Call delegate
    [myFeedVC didMoveToParentViewController:self];
}

/**
 *  It loads the information of the contest table view
 */

- (void)loadCampaigns {
    [WKWinkConnect getCampaignsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOCampaign class]];
      // self.campaingTopVCContainer = [[SSOCampaignTopViewControllerContainer alloc] initWithArrayOfCampaigns:items.response];
      [self.contestActivityIndicator stopAnimating];
      [self.campaignVC setCampaignData:items.response];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

/**
 *  it loads the information of the user's feed collection view
 */

- (void)loadMyFeed {
    [SSOFeedConnect getMyFeedWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
      [self.myFeedActivityIndicator stopAnimating];
      [self.myFeedVC setMyFeedData:items.response];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

#pragma mark - IBActions

/**
 *  Action  of Contest button
 *
 *  @param sender: the button
 */

- (IBAction)contestsButtonAction:(UIButton *)sender {
    if (!self.isContestsVisible) {
        self.contestView.hidden = NO;
        self.myFeedView.hidden = YES;
        [self changeButtonColor];
    }
}

/**
 *  Action  of My Feed button
 *
 *  @param sender: the button
 */

- (IBAction)myFeedButtonAction:(UIButton *)sender {
    if (self.isContestsVisible) {
        self.contestView.hidden = YES;
        self.myFeedView.hidden = NO;
        [self changeButtonColor];
    }
}

#pragma mark - UI

/**
 *  Change the color of the Contest and my feed buttons
 */

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
