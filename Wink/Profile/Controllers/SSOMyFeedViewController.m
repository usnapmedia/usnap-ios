//
//  SSOMyFeedViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-29.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMyFeedViewController.h"
#import <SSOSimpleCollectionViewProvider.h>
#import "SSOMyFeedViewController.h"
#import "SSOMyFeedCollectionViewCell.h"
#import <Masonry.h>

NSString *const kMyFeedCollectionViewCell = @"MyFeedCollectionViewCell";
NSString *const kMyFeedNibNameCollectionViewCell = @"SSOMyFeedCollectionViewCell";

@interface SSOMyFeedViewController ()

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *provider;

@end

@implementation SSOMyFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initializeUI];
//    [self initializeData];
}

- (void)initializeUI {
    self.collectionView = [UICollectionView new];
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
}

- (void)setMyFeedData:(NSArray *)data {
    self.provider.inputData = [NSMutableArray arrayWithArray:data];
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
