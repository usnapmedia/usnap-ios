//
//  SSOMyFeedViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-29.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMyFeedViewController.h"
#import "SSOSimpleCollectionViewProvider.h"
#import "SSOMyFeedViewController.h"
#import "SSOMyFeedCollectionViewCell.h"
#import <Masonry.h>
#import "SSOSnap.h"
#import "SSOPhotoDetailViewController.h"

NSString *const kMyFeedCollectionViewCell = @"MyFeedCollectionViewCell";
NSString *const kMyFeedNibNameCollectionViewCell = @"SSOMyFeedCollectionViewCell";
NSInteger const kCollectionViewMinimumInteritemSpacing = -2;
NSInteger const kCollectionViewMinimumLineSpacing = 5;
NSInteger const kNumberOfColumnsOfCollectionView = 3;
NSInteger const KCollectionViewPadding = 5;
CGFloat const kPercentageHeightWitdhCell = 1.15;

@interface SSOMyFeedViewController () <SSOProviderDelegate>

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *provider;

@end

@implementation SSOMyFeedViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self initializeData];
}

#pragma mark - Initialization

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    // Creating the layout of the collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = kCollectionViewMinimumInteritemSpacing;
    flowLayout.minimumLineSpacing = kCollectionViewMinimumLineSpacing;
    // Creating the size of the collection view cell
    CGFloat width = self.view.frame.size.width / kNumberOfColumnsOfCollectionView - KCollectionViewPadding * 2 -
                    ((kNumberOfColumnsOfCollectionView - 1) * kCollectionViewMinimumInteritemSpacing); // Is 2 because is left and right
    CGFloat height = width * kPercentageHeightWitdhCell;
    flowLayout.itemSize = CGSizeMake(width, height);
    // Adding padding at the collection view (left and right)
    flowLayout.sectionInset = UIEdgeInsetsMake(KCollectionViewPadding, KCollectionViewPadding, KCollectionViewPadding, KCollectionViewPadding);
    // Creating the collection view
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:kMyFeedNibNameCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kMyFeedCollectionViewCell];
}

- (void)initializeData {
    self.provider = [SSOSimpleCollectionViewProvider new];
    self.provider.cellReusableIdentifier = kMyFeedCollectionViewCell;
    self.collectionView.delegate = self.provider;
    self.collectionView.dataSource = self.provider;
    self.provider.delegate = self;
}

#pragma mark - UI

/**
 *  The collection view receive the new data and the collection view is reloaded
 */

- (void)setMyFeedData:(NSArray *)data {
    self.provider.inputData = [NSMutableArray arrayWithArray:data];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSOProviderDelegate

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.provider.inputData objectAtIndex:indexPath.row] isKindOfClass:[SSOSnap class]]) {
        //  detailVC.snap = [self.provider.inputData objectAtIndex:indexPath.row];
        SSOPhotoDetailViewController *detailVC = [[SSOPhotoDetailViewController alloc] initWithSnap:[self.provider.inputData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
