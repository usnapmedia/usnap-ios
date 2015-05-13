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
#import "SSOCampaignDetailViewController.h"
#import <Masonry.h>

#define kTabCollectionViewCellNib @"SSOTopCampaignCollectionViewCell"
#define kCollectionViewCellID @"campaignCell"
#define kCollectionViewCellNIB @"SSOCampaignImageCellCollectionViewCell"

@interface SSOCampaignTopViewControllerContainer () <SSOCampaignProviderDelegate, UIScrollViewDelegate>

@property(strong, nonatomic) UICollectionView *tabCollectionView;
@property(strong, nonatomic) SSOCampaignProvider *provider;
@property(nonatomic, strong) NSArray *arrayOfCampaigns;

@property(nonatomic) NSInteger index;

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

    self.index = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

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
    // Remove bounce, else it creates problem with the willDisplayCell loading a cell it should not.
    self.tabCollectionView.bounces = NO;

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
    }];

    // Reload the data
    [self.tabCollectionView reloadData];
}

/**
 *  It's called when the collection view will change the current cell
 *
 *  @param provider            provider
 *  @param scrollView          scrollView
 *  @param targetContentOffset targetContentOffset
 */

- (void)providerWillEndDragging:(id)provider scrollView:(UIScrollView *)scrollView targetContentOffset:(inout CGPoint *)targetContentOffset {
    // Checks if the it's the collectionView who is scrolling
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        float width = collectionView.frame.size.width;
        // Calculate if the target content offset is bigger than the width of the cell
        int item = round(targetContentOffset->x / width);
        // Checks if the collectionView will display a different cell. This is to avoid to reload the data for the same cell
        if (self.index != item) {
            [self.delegate topViewControllerDidChangeForNewCampaign:[self.arrayOfCampaigns objectAtIndex:item]];
            self.index = item;
        }
    }
}

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SSOCampaignDetailViewController *detailVC = [[SSOCampaignDetailViewController alloc] initWithCampaign:[self.provider.inputData objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
