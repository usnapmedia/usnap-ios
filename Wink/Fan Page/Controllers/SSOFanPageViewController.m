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
#import <Masonry.h>

@interface SSOFanPageViewController ()

@property(strong, nonatomic) SSOCampaignTopViewControllerContainer *campaingTopVCContainer;
@property(weak, nonatomic) IBOutlet UIView *campaignViewControllerContainer;

@end

@implementation SSOFanPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCampaigns];

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

#pragma mark - XLPagerTabStripViewControllerDelegate

/**
 *  Delegate method returned when changing the campaign in the topVC
 *
 *  @param pagerTabStripViewController the topVC
 *  @param fromIndex                   the index we are coming from
 *  @param toIndex                     the index we are going to
 */
- (void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
           updateIndicatorFromIndex:(NSInteger)fromIndex
                            toIndex:(NSInteger)toIndex {
}

@end
