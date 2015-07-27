//
//  SSOSnapViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSnapViewController.h"
#import "SSOPhotosViewController.h"
#import "SSOFeedConnect.h"
#import "SSOSnap.h"
#import "SSOCountableItems.h"
#import "SSSessionManager.h"
#import <Masonry.h>
#import "SSOThemeHelper.h"

@interface SSOSnapViewController ()

@property(weak, nonatomic) IBOutlet UIView *customNavBar;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property(strong, nonatomic) NSDictionary *queryParam;

@property(strong, nonatomic) SSOPhotosViewController *photosVC;

@end

@implementation SSOSnapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self setChildVC];
    [self initializeData];
    [self refreshData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Initialization

- (void)initializeData {
    self.queryParam = @{ @"type" : @"image" };
}

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    //@FIXME
    self.customNavBar.backgroundColor = [UIColor blackColor];
    self.segmentedControl.tintColor = [SSOThemeHelper firstColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[SSOThemeHelper avenirLightFontWithSize:14] forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

/**
 *  Add the table view to the container
 */

- (void)setChildVC {
    // Set child VC
    self.photosVC = [SSOPhotosViewController new];
    // Add the child vc
    [self addChildViewController:self.photosVC];
    // Set the frame
    self.photosVC.view.frame = self.containerView.frame;
    //
    [self.containerView addSubview:self.photosVC.view];
    [self.photosVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.containerView);
    }];
    // Call delegate
    [self.photosVC didMoveToParentViewController:self];
}

#pragma mark - Data

- (void)refreshData {
    if (self.isTopPhotos) {
        [self loadTopPhotos];
    } else {
        [self loadLatestPhotos];
    }
}

- (void)loadTopPhotos {
    //@FIXME should be all photos, not ony the top ones]
    [SSOFeedConnect getTopPhotosForCampaignId:[SSSessionManager sharedInstance].campaignID
        withParameters:self.queryParam
        withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
          [self.photosVC setPhotosData:items.response];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){

        }];
}

- (void)loadLatestPhotos {
    [SSOFeedConnect getRecentPhotosForCampaignId:[SSSessionManager sharedInstance].campaignID
        withParameters:self.queryParam
        withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
          [self.photosVC setPhotosData:items.response];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){

        }];
}

#pragma mark - IBActions

/**
 *  Action  of back button
 *
 *  @param sender: the button
 */

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterValueHasChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
    case 0:
        self.queryParam = @{ @"type" : @"image" };
        break;
    case 1:
        self.queryParam = @{ @"type" : @"video" };

        break;
    case 2:
        self.queryParam = nil;
        break;
    default:
        break;
    }
    [self refreshData];
}

@end
