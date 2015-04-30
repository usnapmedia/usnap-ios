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

NSString *const kPhotosCollectionViewCell = @"PhotosCollectionViewCell";
NSString *const kPhotosNibNameCollectionViewCell = @"SSOPhotosCollectionViewCell";
NSInteger const kPhotosCollectionViewMinimumInteritemSpacing = 1;
NSInteger const kPhotosCollectionViewMinimumLineSpacing = 3;
NSInteger const kPhotosNumberOfColumnsOfCollectionView = 4;
NSInteger const KPhotosCollectionViewPadding = 0;
CGFloat const kPhotosPercentageHeightWitdhCell = 1;

@interface SSOPhotosViewController ()

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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = kPhotosCollectionViewMinimumInteritemSpacing;
    flowLayout.minimumLineSpacing = kPhotosCollectionViewMinimumLineSpacing;
    // Creating the size of the collection view cell
    CGFloat width = self.view.frame.size.width / kPhotosNumberOfColumnsOfCollectionView - (KPhotosCollectionViewPadding * 2) -
                    ((kPhotosNumberOfColumnsOfCollectionView - 1) * kPhotosCollectionViewMinimumInteritemSpacing); // Is 2 because is left and right
    CGFloat height = width * kPhotosPercentageHeightWitdhCell;
    flowLayout.itemSize = CGSizeMake(width, height);
    // Adding padding at the collection view (left and right)
    flowLayout.sectionInset = UIEdgeInsetsMake(0, KPhotosCollectionViewPadding, 0, KPhotosCollectionViewPadding);
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

@end
