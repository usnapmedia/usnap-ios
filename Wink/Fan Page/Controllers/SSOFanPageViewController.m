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
#import "SSOFeedConnect.h"
#import <Masonry.h>

#define kTopPhotosNib @"SSOTopPhotosCollectionViewCell"
#define kTopPhotosReusableId @"topPhotosCell"

@interface SSOFanPageViewController () <TopContainerFanPageDelegate>

@property(strong, nonatomic) SSOCampaignTopViewControllerContainer *campaingTopVCContainer;
@property(strong, nonatomic) SSOTopPhotosViewController *topPhotosVC;
@property(weak, nonatomic) IBOutlet UIView *campaignViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *topPhotosViewControllerContainer;
@property(weak, nonatomic) IBOutlet UIView *livePhotosViewControllerContainer;

@end

@implementation SSOFanPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCampaigns];
    [self initializeTopPhotosController];
    [self loadTopPhotos];

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

- (void)loadTopPhotos {
    [SSOFeedConnect getTopPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
      [self.topPhotosVC setData:items.response withCellNib:kTopPhotosNib andCellReusableIdentifier:kTopPhotosReusableId];
      // Hide the loading overlay
      [self.topPhotosVC hideLoadingOverlay];
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
