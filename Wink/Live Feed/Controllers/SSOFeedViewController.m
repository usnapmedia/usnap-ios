//
//  SSOFeedViewController.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFeedViewController.h"
#import "SSOFeedConnect.h"
#import "SSOCountableItems.h"
#import <SSOSimpleCollectionViewProvider.h>
#import <Masonry.h>

#define kImageCollectionViewCell @"imageCollectionViewCell"
#define kImageCollectionViewCellNib @"SSOImageCollectionViewCell"

@interface SSOFeedViewController ()

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) SSOSimpleCollectionViewProvider *provider;

@end

@implementation SSOFeedViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeData];
    [self initializeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

/**
 *  Initialize the UI for the VC
 */
- (void)initializeUI {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
}

/**
 *  Initialize the data of the VC
 */
- (void)initializeData {
    // Set the flow layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    // Initialize the view
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.provider = [SSOSimpleCollectionViewProvider new];

    self.collectionView.delegate = self.provider;
    self.collectionView.dataSource = self.provider;

    [self.collectionView registerNib:[UINib nibWithNibName:kImageCollectionViewCellNib bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kImageCollectionViewCell];

    //@TODO Set the data for the datasource
    self.provider.cellReusableIdentifier = kImageCollectionViewCell;

    [self loadLatestImages];
}

/**
 *  Load the latest images from the backend
 */
- (void)loadLatestImages {
    UIView *overlayView = [UIView new];
    overlayView.backgroundColor = [UIColor lightGrayColor];
    overlayView.alpha = 0.75f;
    UIActivityIndicatorView *activityView = [UIActivityIndicatorView new];
    [self.view addSubview:overlayView];
    [overlayView addSubview:activityView];
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(overlayView);
    }];
    [activityView startAnimating];

    [SSOFeedConnect getliveFeedPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      [overlayView setHidden:YES];
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject];
      self.provider.inputData = [items.response mutableCopy];
      [self.collectionView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [overlayView setHidden:YES];
    }];
}

//@TODO
- (NSMutableArray *)arrayImages {
    return @[
        [UIImage imageNamed:@"Alien"],
        [UIImage imageNamed:@"hankey"],
        [UIImage imageNamed:@"Unknown"],
        [UIImage imageNamed:@"Alien"],
        [UIImage imageNamed:@"hankey"],
        [UIImage imageNamed:@"Unknown"],
        [UIImage imageNamed:@"Alien"],
        [UIImage imageNamed:@"hankey"],
        [UIImage imageNamed:@"Unknown"]
    ].mutableCopy;
}

@end
