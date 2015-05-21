//
//  SSOFanPageViewController.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFanPageViewController.h"
#import "SSOCampaignTopViewControllerContainer.h"
#import "SSSessionManager.h"
#import "WKWinkConnect.h"
#import "SSOCountableItems.h"
#import "SSOSnap.h"
#import "SSOTopPhotosViewController.h"
#import "SSORecentPhotosViewController.h"
#import "SSOFeedConnect.h"
#import "SSOThemeHelper.h"
#import "SSOScreenSizeHelper.h"
#import <Masonry.h>

@interface SSOFanPageViewController () <TopContainerFanPageDelegate>

/**
 *  Container controller
 */
@property(strong, nonatomic) SSOCampaignTopViewControllerContainer *campaingTopVCContainer;
@property(strong, nonatomic) SSOTopPhotosViewController *topPhotosVC;
@property(strong, nonatomic) SSORecentPhotosViewController *recentPhotosVC;

/**
 *  IBOutlets
 */
@property(weak, nonatomic) IBOutlet UIView *campaignViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *topPhotosViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *recentPhotosViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *customNavigationBar;

@property(strong, nonatomic) SSOCampaign *currentCampaign;

@end

@implementation SSOFanPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize UI
    [self initializeUI];

    // Initialize the VCs
    [self initializeTopPhotosController];
    [self initializeRecentPhotosController];

    // Do any additional setup after loading the view.
    // Load the campaigns
    [self loadCampaigns];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[SSSessionManager sharedInstance].campaignID isEqualToString:self.currentCampaign.id]) {
        self.currentCampaign = [self.campaingTopVCContainer setAndScrollToCampaignWithCampaignID:[SSSessionManager sharedInstance].campaignID];
    }

    // Load the data
    if (self.currentCampaign) {
        [self loadTopPhotos];
        [self loadRecentPhotos];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)initializeUI {
    //@FIXME
    self.customNavigationBar.backgroundColor = [UIColor blackColor];
}

- (void)initializeCampaignTopViewControllerWithCampaigns:(NSArray *)campaigns {
    // Set the height of
    [self.campaignViewControllerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.equalTo([NSNumber numberWithFloat:[SSOScreenSizeHelper campaignViewControllerHeightConstraint]]);
    }];

    // Set child VC
    SSOCampaignTopViewControllerContainer *containerVC = [[SSOCampaignTopViewControllerContainer alloc] initWithArrayOfCampaigns:campaigns];
    containerVC.delegate = self;
    // Add the child vc
    [self addChildViewController:containerVC];
    [self.campaignViewControllerContainer addSubview:containerVC.view];
    [containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.campaignViewControllerContainer);
    }];
    // Call delegate
    [containerVC didMoveToParentViewController:self];

    self.campaingTopVCContainer = containerVC;
}

/**
 *  Initialize top photos container controller
 */
- (void)initializeTopPhotosController {
    self.topPhotosVC = [SSOTopPhotosViewController new];

    [self addChildViewController:self.topPhotosVC];

    [self.topPhotosViewControllerContainer addSubview:self.topPhotosVC.view];

    [self.topPhotosVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.topPhotosViewControllerContainer);
    }];

    [self.topPhotosVC didMoveToParentViewController:self];
    // Display the loading overlay before the data loads
    [self.topPhotosVC displayLoadingOverlay];
}

/**
 *  Initialize the recent photos controller
 */
- (void)initializeRecentPhotosController {
    self.recentPhotosVC = [SSORecentPhotosViewController new];
    [self addChildViewController:self.recentPhotosVC];
    [self.recentPhotosViewControllerContainer addSubview:self.recentPhotosVC.view];
    [self.recentPhotosVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.recentPhotosViewControllerContainer);
    }];
    [self.recentPhotosVC didMoveToParentViewController:self];
    // Display the loading overlay before the data loads
    [self.recentPhotosVC displayLoadingOverlay];
}

#pragma mark - Data

/**
 *  Fetch the campaigns from the backend
 */
- (void)loadCampaigns {

    [WKWinkConnect getCampaignsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOCampaign class]];
      [self initializeCampaignTopViewControllerWithCampaigns:items.response];
      NSAssert([[items.response firstObject] isKindOfClass:[SSOCampaign class]], @"Need to pass a campaign object here");
      // Set current campaign to be the first campaign
      self.currentCampaign = [items.response firstObject];
      // Load top photos and recent photos
      [self loadTopPhotos];
      [self loadRecentPhotos];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

/**
 *  Load top photos and assign them to the VC
 */
- (void)loadTopPhotos {
    // Display loading UI
    [self.topPhotosVC displayLoadingOverlay];

    [SSOFeedConnect getTopPhotosForCampaignId:self.currentCampaign.id
        withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
          [self.topPhotosVC setData:items.response withCellNib:kTopPhotosNib andCellReusableIdentifier:kTopPhotosReusableId];
          // Hide the loading overlay
          [self.topPhotosVC hideLoadingOverlay];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
        }];
}

/**
 *  Load the latest photos and assign them to the VC
 */
- (void)loadRecentPhotos {
    // Display loading UI
    [self.recentPhotosVC displayLoadingOverlay];

    [SSOFeedConnect getRecentPhotosForCampaignId:self.currentCampaign.id
        withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          // Set the recent photos
          SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
          [self.recentPhotosVC setInputData:items.response.mutableCopy];
          // Hide the loading overlay
          [self.recentPhotosVC hideLoadingOverlay];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
        }];
}

#pragma mark - TopContainerFanPageDelegate

/**
 *  Delegate method from the topContainer called after the user swiped to a new campaign
 *
 *  @param newCampaign the new campaign displayed
 */
- (void)topViewControllerDidChangeForNewCampaign:(SSOCampaign *)newCampaign {

    // Set the new campagin ID
    [[SSSessionManager sharedInstance] setCampaignID:newCampaign.id];

    self.currentCampaign = newCampaign;
    // Load new photos
    [self loadTopPhotos];
    [self loadRecentPhotos];
}

@end
