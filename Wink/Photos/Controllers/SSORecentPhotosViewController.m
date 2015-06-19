//
//  SSORecentPhotosViewController.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSORecentPhotosViewController.h"
#import "SSODynamicCellSizeCollectionViewProvider.h"
#import "SSOUSnapLightButton.h"
#import "SSOGrayBackgroundWithBorderView.h"
#import <Masonry.h>
#import "SSOPhotoDetailViewController.h"
#import "SSOSnapViewController.h"
#import "SSOThemeHelper.h"

NSInteger const kRecentPhotosCellWidth = 25;
NSInteger const kRecentPhotosCellOffset = 10;

@interface SSORecentPhotosViewController () <SSOProviderDelegate>

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) UIView *overlayView;
@property(strong, nonatomic) UIActivityIndicatorView *loadingSpinner;
@property(strong, nonatomic) SSODynamicCellSizeCollectionViewProvider *provider;
@property(strong, nonatomic) UIView *topView;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) SSOUSnapLightButton *seeAllButton;

@end

@implementation SSORecentPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeData];
    [self initializeUI];
    [self setLoadingOverlay];
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
    self.topView = [UIView new];
    self.titleLabel = [UILabel new];
    self.titleLabel.text = NSLocalizedString(@"fan-page.recent-photos.title-label", @"Recent photos title");
    self.seeAllButton = [SSOUSnapLightButton new];
    [self.seeAllButton setTitle:NSLocalizedString(@"fan-page.see-all-button", @"See all button title") forState:UIControlStateNormal];
    [self.seeAllButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.seeAllButton addTarget:self action:@selector(seeAllTopSnapsAction) forControlEvents:UIControlEventTouchUpInside];

    // Set the flow layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // Initialize the view
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [self.collectionView setScrollEnabled:YES];
    // Add pagging on top and bottom
    self.collectionView.contentInset = UIEdgeInsetsMake(2.5, 2, 2.5, 2);
    //@TODO Generic?
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.provider = [SSODynamicCellSizeCollectionViewProvider new];
    self.provider.delegate = self;
    self.collectionView.delegate = self.provider;
    self.collectionView.dataSource = self.provider;

    // Register and set the reusable ID
    [self.collectionView registerNib:[UINib nibWithNibName:kPhotosNibNameCollectionViewCell bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kPhotosCollectionViewCell];
    self.provider.cellReusableIdentifier = kPhotosCollectionViewCell;
}

/**
 *  Initialization of the UI
 */
- (void)initializeUI {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.seeAllButton];

    // Set the see all button constraints
    [self.seeAllButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    // Create the constraints
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.and.left.and.right.equalTo(self.view);
      make.height.equalTo([NSNumber numberWithInteger:kTopViewHeightConstraint]);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.topView.mas_bottom).with.offset(-5);
      make.left.equalTo(self.topView);
      make.right.equalTo(self.seeAllButton.mas_left).with.offset(-kConstraintOffset);

    }];

    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.topView.mas_bottom).with.offset(-2);
      make.right.equalTo(self.topView).with.offset(-kConstraintOffset);
      make.width.equalTo([NSNumber numberWithInteger:kButtonWidthConstraint]);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.and.bottom.equalTo(self.view);
      make.right.equalTo(self.view).with.offset(-5);
      make.top.equalTo(self.topView.mas_bottom);
    }];

    self.titleLabel.font = [SSOThemeHelper avenirLightFontWithSize:19];
    self.seeAllButton.titleLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
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

#pragma mark - Setter

/**
 *  Set the data for the provider
 *
 *  @param data the data
 */
- (void)setInputData:(NSMutableArray *)data {
    self.provider.inputData = data;
    [self.collectionView reloadData];
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

#pragma mark - IBActions

/**
 *  Action of the button See All
 */

- (void)seeAllTopSnapsAction {
    SSOSnapViewController *snapVC = [SSOSnapViewController new];
    snapVC.isTopPhotos = NO;
    [self.navigationController pushViewController:snapVC animated:YES];
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
