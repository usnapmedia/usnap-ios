//
//  SSOPhotosViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOPhotosViewController.h"
#import <SSOSimpleCollectionViewProvider.h>
#import <Masonry.h>
#import "SSOPhotoDetailViewController.h"

NSInteger const kPhotosCollectionViewMinimumInteritemSpacing = 0;
NSInteger const kPhotosCollectionViewMinimumLineSpacing = 5;
NSInteger const kPhotosNumberOfColumnsOfCollectionView = 4;
NSInteger const KPhotosCollectionViewPadding = 5;
CGFloat const kPhotosPercentageHeightWitdhCell = 1;

@interface SSOPhotosViewController () <SSOProviderDelegate>

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *provider;

@end

@implementation SSOPhotosViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUI];
    [self initializeData];
}

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    // Creating the layout of the collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = kPhotosCollectionViewMinimumInteritemSpacing;
    flowLayout.minimumLineSpacing = kPhotosCollectionViewMinimumLineSpacing;
    // Creating the size of the collection view cell
    CGFloat width = self.view.frame.size.width / kPhotosNumberOfColumnsOfCollectionView - KPhotosCollectionViewPadding * 2 -
                    ((kPhotosNumberOfColumnsOfCollectionView - 1) * kPhotosCollectionViewMinimumInteritemSpacing); // Is 2 because is left and right
    CGFloat height = width * kPhotosPercentageHeightWitdhCell;
    flowLayout.itemSize = CGSizeMake(width, height);
    // Adding padding at the collection view (left and right)
    flowLayout.sectionInset =
        UIEdgeInsetsMake(KPhotosCollectionViewPadding, KPhotosCollectionViewPadding, KPhotosCollectionViewPadding, KPhotosCollectionViewPadding);
    // Creating the collection view
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:kPhotosNibNameCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kPhotosCollectionViewCell];
}

- (void)initializeData {
    self.provider = [SSOSimpleCollectionViewProvider new];
    self.provider.cellReusableIdentifier = kPhotosCollectionViewCell;
    self.collectionView.delegate = self.provider;
    self.collectionView.dataSource = self.provider;
    self.provider.delegate = self;
}

#pragma mark - UI

/**
 *  The collection view receive the new data and the collection view is reloaded
 */

- (void)setPhotosData:(NSArray *)data {
    self.provider.inputData = [NSMutableArray arrayWithArray:data];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.provider.inputData objectAtIndex:indexPath.row] isKindOfClass:[SSOSnap class]]) {
        //  detailVC.snap = [self.provider.inputData objectAtIndex:indexPath.row];
        SSOPhotoDetailViewController *detailVC = [[SSOPhotoDetailViewController alloc] initWithSnap:[self.provider.inputData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end