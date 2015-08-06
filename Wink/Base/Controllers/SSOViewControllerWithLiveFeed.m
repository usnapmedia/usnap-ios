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
#import "SSOPhotoDetailViewController.h"
#import "SSSessionManager.h"
#import "SSOSimpleCollectionViewProvider.h"
#import <Masonry.h>

#define kFeedContainerHeight 55
#define kFeedContainerLeft 45

@interface SSOViewControllerWithLiveFeed () <SSOProviderDelegate>

@property(strong, nonatomic) SSOFeedViewController *childVc;
@property(strong, nonatomic) UIButton *dismissButton;

@end

@implementation SSOViewControllerWithLiveFeed

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the view
    [self initializeFeedContainerView];
    [self initializeFeedController];
    //[self createDismissButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.childVc.provider.inputData = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
      make.top.and.right.and.left.equalTo(self.view);
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

    // Overide the collectionView flow from superClass and set the desired spacing.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    self.childVc.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);

    self.childVc.collectionView.collectionViewLayout = flowLayout;
}

/**
 *  Dismiss Button for the Camera
 */
// TODO:  Check if needed in the end
- (void)createDismissButton {
    self.dismissButton = [UIButton new];
    //@FIXME Design will probably change
    [self.dismissButton setTitle:@"X" forState:UIControlStateNormal];
    self.dismissButton.backgroundColor = self.childVc.collectionView.backgroundColor;
    [self.dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.dismissButton];
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.and.left.equalTo(self.view);
      make.height.equalTo([NSNumber numberWithInt:kFeedContainerHeight]);
      make.width.equalTo([NSNumber numberWithInt:kFeedContainerLeft]);
    }];
    [self.dismissButton addTarget:self action:@selector(buttonWasClicked) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  Action of the dismiss button
 */

- (void)buttonWasClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Set the images to the view controller
 *
 *  @param childVC the child vc
 */
- (void)fetchLatestImagesAndSendToController {
    // If there is no campaign, the default route is used
    [SSOFeedConnect getRecentPhotosForCampaignId:[SSSessionManager sharedInstance].campaignID
        withParameters:nil
        withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOSnap class]];
          // Set the data of the VC
          NSUInteger maxPhotos = MIN(kNumberOfTopPhotos, [items.response count]);
          NSArray *subrangeOfArray = [items.response subarrayWithRange:NSMakeRange(0, maxPhotos)];
          [self.childVc setData:subrangeOfArray withCellNib:@"SSOPhotosCollectionViewCell" andCellReusableIdentifier:kPhotosCollectionViewCell];
          [self.childVc hideLoadingOverlay];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
        }];
}

#pragma mark - SSOProviderDelegate

/**
 *  When the user tap on the photo, it will display the details of the photo
 *
 *  @param provider  provider
 *  @param indexPath index of the row
 */

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SSOCustomCellSizeCollectionViewProvider *prov = provider;
    if ([[prov.inputData objectAtIndex:indexPath.row] isKindOfClass:[SSOSnap class]]) {
        //  detailVC.snap = [self.provider.inputData objectAtIndex:indexPath.row];
        SSOPhotoDetailViewController *detailVC = [[SSOPhotoDetailViewController alloc] initWithSnap:[prov.inputData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
