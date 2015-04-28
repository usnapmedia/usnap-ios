//
//  SSOViewControllerWithLiveFeed.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOViewControllerWithLiveFeed.h"
#import "SSOFeedViewController.h"
#import "SSOFeedConnect.h"
#import "SSOFanPageViewController.h"
#import "SSOCountableItems.h"
#import "SSOSnap.h"
#import <SSOSimpleCollectionViewProvider.h>
#import <Masonry.h>

#define kFeedContainerHeight 55

@interface SSOViewControllerWithLiveFeed () <SSOProviderDelegate>

@property(strong, nonatomic) SSOFeedViewController *childVc;

@end

@implementation SSOViewControllerWithLiveFeed

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the view
    [self initializeFeedContainerView];
    [self initializeFeedController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchLatestImagesAndSendToController];
}

#pragma mark - Initialization

/**
 *  Initialize the container view
 */
- (void)initializeFeedContainerView {
    self.feedContainerView = [UIView new];
    [self.view addSubview:self.feedContainerView];
    [self.feedContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.and.left.and.right.equalTo(self.view);
      make.height.equalTo([NSNumber numberWithInt:kFeedContainerHeight]);
    }];
}

/**
 *  Initialize the feed view controller
 */
- (void)initializeFeedController {
    self.childVc = [SSOFeedViewController new];
    // Fetch the latest pictures
    // Add the child vc
    [self addChildViewController:self.childVc];
    // Set the frame
    self.childVc.view.frame = self.feedContainerView.frame;
    //    // Add subview
    [self.feedContainerView addSubview:self.childVc.view];
    // Call delegate
    [self.childVc didMoveToParentViewController:self];

    //  Make the view delegate for the provider to access the on select event
    self.childVc.provider.delegate = self;
}

/**
 *  Set the images to the view controller
 *
 *  @param childVC the child vc
 */
- (void)fetchLatestImagesAndSendToController {
    [SSOFeedConnect getRecentPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
      // Set the data of the VC
      [self.childVc setData:items.response withCellNib:kImageCollectionViewCellNib andCellReusableIdentifier:kImageCollectionViewCell];
      [self.childVc hideLoadingOverlay];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}

#pragma mark - SSOProviderDelegate

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //@TODO Present fan page
    [self presentViewController:[SSOFanPageViewController new] animated:YES completion:nil];
}

@end
