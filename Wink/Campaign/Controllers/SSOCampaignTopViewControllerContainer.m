//
//  SSOCampaignTopViewController.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignTopViewControllerContainer.h"
#import "WKWinkConnect.h"
#import "SSOCampaignProvider.h"
#import <Masonry.h>

#define kTabCollectionViewCellNib @"SSOTopCampaignCollectionViewCell"
#define kCollectionViewCellID @"campaignCell"
#define kCollectionViewCellNIB @"SSOCampaignImageCellCollectionViewCell"

@interface SSOCampaignTopViewControllerContainer () <SSOCampaignProviderDelegate>

@property(strong, nonatomic) UICollectionView *tabCollectionView;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *provider;
@property(nonatomic, strong) NSArray *arrayOfCampaigns;

@end

@implementation SSOCampaignTopViewControllerContainer

- (instancetype)initWithArrayOfCampaigns:(NSArray *)campaigns {

    if (self = [super init]) {

        self.arrayOfCampaigns = campaigns;
    }

    return self;
}

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

    self.view.backgroundColor = [UIColor clearColor];
    // Set the flow layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;

    self.tabCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];

    self.tabCollectionView.backgroundColor = [UIColor clearColor];

    // Add paging to collectionView
    self.tabCollectionView.pagingEnabled = YES;

    self.tabCollectionView.collectionViewLayout = flowLayout;
    // Initialize the view
    self.tabCollectionView.showsHorizontalScrollIndicator = NO;

    // Init the provider with collectionViews and data
    self.provider = [[SSOCampaignProvider alloc] initWithTabCollectionView:self.tabCollectionView andInputData:self.arrayOfCampaigns.mutableCopy];
    self.provider.delegate = self;

    // Set the delegates and dataSources
    self.tabCollectionView.delegate = self.provider;
    self.tabCollectionView.dataSource = self.provider;

    // Set the reusableIdentifiers for the cells
    [self.tabCollectionView registerNib:[UINib nibWithNibName:kTabCollectionViewCellNib bundle:[NSBundle mainBundle]]
             forCellWithReuseIdentifier:kCollectionViewCellID];
    self.provider.cellReusableIdentifier = kCollectionViewCellID;

    // Add the collectionViews to the view
    [self.view addSubview:self.tabCollectionView];

    // Add constraints
    [self.tabCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
      make.height.equalTo(@50);
    }];

    // Reload the data
    [self.tabCollectionView reloadData];
}

- (void)provider:(id)provider willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    [self.delegate topViewControllerDidChangeForNewCampaign:[self.arrayOfCampaigns objectAtIndex:indexPath.row]];
    NSLog(@"indexPath : %@   cell : %@", indexPath, cell);
}

@end
