//
//  SSOFanPageViewController.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFanPageViewController.h"
#import "SSOCampaignTopViewControllerContainer.h"
#import "WKWinkConnect.h"
#import "SSOCountableItems.h"
#import "SSOSnap.h"
#import "SSOTopPhotosViewController.h"
#import "SSORecentPhotosViewController.h"
#import "SSOFeedConnect.h"
#import <Masonry.h>

@interface SSOFanPageViewController () <TopContainerFanPageDelegate>

@property(strong, nonatomic) SSOCampaignTopViewControllerContainer *campaingTopVCContainer;
@property(strong, nonatomic) SSOTopPhotosViewController *topPhotosVC;
@property(strong, nonatomic) SSORecentPhotosViewController *recentPhotosVC;
@property(weak, nonatomic) IBOutlet UIView *campaignViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *topPhotosViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *recentPhotosViewControllerContainer;

@end

@implementation SSOFanPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // Initialize the VCs
    [self initializeTopPhotosController];
    [self initializeRecentPhotosController];

    // Load the data
    [self loadCampaigns];
    [self loadTopPhotos];
    [self loadRecentPhotos];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeCampaignTopViewControllerWithCampaigns:(NSArray *)campaigns {
    // Set child VC
    SSOCampaignTopViewControllerContainer *containerVC = [[SSOCampaignTopViewControllerContainer alloc] initWithArrayOfCampaigns:campaigns];
    containerVC.delegate = self;
    // Add the child vc
    [self addChildViewController:containerVC];
    // Set the frame
    containerVC.view.frame = self.campaignViewControllerContainer.frame;
    //
    [self.campaignViewControllerContainer addSubview:containerVC.view];
    [containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.campaignViewControllerContainer);
    }];
    // Call delegate
    [containerVC didMoveToParentViewController:self];
}

/**
 *  Initialize top photos container controller
 */
- (void)initializeTopPhotosController {
    self.topPhotosVC = [SSOTopPhotosViewController new];

    [self addChildViewController:self.topPhotosVC];
    // Set the frame
    self.topPhotosVC.view.frame = self.topPhotosViewControllerContainer.frame;
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
    // Set the frame
    self.recentPhotosVC.view.frame = self.recentPhotosViewControllerContainer.frame;
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
      // self.campaingTopVCContainer = [[SSOCampaignTopViewControllerContainer alloc] initWithArrayOfCampaigns:items.response];
      [self initializeCampaignTopViewControllerWithCampaigns:items.response];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

/**
 *  Load top photos and assign them to the VC
 */
- (void)loadTopPhotos {
    // Display loading UI
    [self.topPhotosVC displayLoadingOverlay];

    [SSOFeedConnect getTopPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
      [self.topPhotosVC setData:items.response withCellNib:kTopPhotosNib andCellReusableIdentifier:kTopPhotosReusableId];
      // Hide the loading overlay
      [self.topPhotosVC hideLoadingOverlay];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}

/**
 *  Load the latest photos and assign them to the VC
 */
- (void)loadRecentPhotos {
    // Display loading UI
    [self.recentPhotosVC displayLoadingOverlay];

    [SSOFeedConnect getRecentPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      // Set the recent photos
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
      [self.recentPhotosVC setInputData:items.response.mutableCopy];
      // Hide the loading overlay
      [self.recentPhotosVC hideLoadingOverlay];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}

#pragma mark - TopContainerFanPageDelegate

/**
 *  Delegate method from the topContainer called after the user swiped to a new campaign
 *
 *  @param newCampaign the new campaign displayed
 */
- (void)topViewControllerDidChangeForNewCampaign:(SSOCampaign *)newCampaign {

    NSLog(@" the new campaign is : %@", newCampaign);
}

@end
