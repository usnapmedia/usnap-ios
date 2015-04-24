//
//  SSOCampaignTopViewController.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignTopViewControllerContainer.h"
#import <SSOSimpleCollectionViewProvider.h>
#import "WKWinkConnect.h"

#define kTabCollectionViewCellNib @""
#define kTabCollectionViewCell @""

@interface SSOCampaignTopViewControllerContainer () <SSOProviderDelegate>

@property(strong, nonatomic) UICollectionView *tabCollectionView;
@property(strong, nonatomic) UICollectionView *imageCollectionView;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *topProvider;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *imageProvider;

@end

@implementation SSOCampaignTopViewControllerContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Initialize the data of the VC
 */
- (void)initializeData {
    // Set the flow layout
    UICollectionViewFlowLayout *flowLayoutTop = [[UICollectionViewFlowLayout alloc] init];
    [flowLayoutTop setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    // Initialize the view
    self.tabCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayoutTop];
    self.tabCollectionView.showsHorizontalScrollIndicator = NO;
    self.topProvider = [SSOSimpleCollectionViewProvider new];

    self.tabCollectionView.delegate = self.topProvider;
    self.tabCollectionView.dataSource = self.topProvider;

    [self.tabCollectionView registerNib:[UINib nibWithNibName:kTabCollectionViewCellNib bundle:[NSBundle mainBundle]]
             forCellWithReuseIdentifier:kTabCollectionViewCell];

    self.topProvider.cellReusableIdentifier = kTabCollectionViewCell;

    // Set the flow layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    // Initialize the view
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.imageCollectionView.showsHorizontalScrollIndicator = NO;
    self.imageProvider = [SSOSimpleCollectionViewProvider new];

    self.imageCollectionView.delegate = self.imageProvider;
    self.imageCollectionView.dataSource = self.imageProvider;

    [self.imageCollectionView registerNib:[UINib nibWithNibName:kTabCollectionViewCellNib bundle:[NSBundle mainBundle]]
               forCellWithReuseIdentifier:kTabCollectionViewCell];

    self.imageProvider.cellReusableIdentifier = kTabCollectionViewCell;
}

- (void)loadDataForCollectionViews {

    [WKWinkConnect getCampaignsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        se 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

@end
