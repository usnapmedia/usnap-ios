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
#import "SSOSnap.h"
#import <Masonry.h>

#define kDefaultCellOffset 5.0f

@interface SSOFeedViewController () <SSOProviderDelegate>

@property(strong, nonatomic, readwrite) UICollectionView *collectionView;
@property(strong, nonatomic) UIView *overlayView;
@property(strong, nonatomic) UIActivityIndicatorView *loadingSpinner;
@property(strong, nonatomic, readwrite) SSOCustomCellSizeCollectionViewProvider *provider;

@end

@implementation SSOFeedViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeData];
    [self initializeUI];
    [self setLoadingOverlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

/**
 *  Lazy instanciation
 *
 *  @return the provider
 */
- (SSOSimpleCollectionViewProvider *)provider {
    if (!_provider) {
        _provider = [SSOCustomCellSizeCollectionViewProvider new];
        _provider.parentVC = self;
    }
    return _provider;
}

- (CGSize)cellSize {
    return CGSizeMake(self.collectionView.frame.size.height - kDefaultCellOffset, self.collectionView.frame.size.height - kDefaultCellOffset);
}

#pragma mark - Setters

- (void)setData:(NSArray *)data withCellNib:(NSString *)cellNib andCellReusableIdentifier:(NSString *)reusableID {
    // Register and set the reusable ID
    [self.collectionView registerNib:[UINib nibWithNibName:cellNib bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reusableID];
    self.provider.cellReusableIdentifier = reusableID;
    // Set the data then reload the collection view
    self.provider.inputData = data.mutableCopy;
    [self.collectionView reloadData];
}

#pragma mark - Initialization

/**
 *  Initialize the UI for the VC
 */
- (void)initializeUI {
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
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
    //@TODO Generic?
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self.provider;
    self.collectionView.dataSource = self.provider;
}

/**
 *  Set a loading overlay while the data loads
 */
- (void)setLoadingOverlay {
    self.overlayView = [UIView new];
    self.overlayView.backgroundColor = [UIColor lightGrayColor];
    self.overlayView.alpha = 0.75f;
    self.loadingSpinner = [UIActivityIndicatorView new];
    [self.view addSubview:self.overlayView];
    [self.overlayView addSubview:self.loadingSpinner];
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    [self.loadingSpinner mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.overlayView);
    }];
    [self.loadingSpinner startAnimating];
}

#pragma mark - Animations

- (void)displayLoadingOverlay {
    self.overlayView.hidden = NO;
    [self.loadingSpinner startAnimating];
}

- (void)hideLoadingOverlay {
    self.overlayView.hidden = YES;
    [self.loadingSpinner stopAnimating];
}

@end
