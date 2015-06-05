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

@property(strong, nonatomic) SSOPhotosViewController *photosVC;

@end

@implementation SSOSnapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self setChildVC];
    [self loadPhotos];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Initialization

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    //@FIXME
    self.customNavBar.backgroundColor = [UIColor blackColor];
    self.segmentedControl.tintColor = [SSOThemeHelper firstColor];
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

- (void)loadPhotos {
    //@FIXME should be all photos, not ony the top ones
    [SSOFeedConnect getTopPhotosForCampaignId:[SSSessionManager sharedInstance].campaignID
                                  withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
      [self.photosVC setPhotosData:items.response];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
