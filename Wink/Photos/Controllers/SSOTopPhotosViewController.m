//
//  SSOTopPhotosViewController.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTopPhotosViewController.h"
#import "SSOCustomCellSizeCollectionViewProvider.h"
#import "SSOUSnapLightButton.h"
#import "SSOGrayBackgroundWithBorderView.h"
#import "SSOSnapViewController.h"
#import "SSOFanPageViewController.h"
#import <Masonry.h>
#import "SSOPhotoDetailViewController.h"
#import "SSOThemeHelper.h"

NSInteger const kTopPhotosCellTextHeight = 40;

@interface SSOTopPhotosViewController () <SSOProviderDelegate>

@property(strong, nonatomic) UIView *topView;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) SSOUSnapLightButton *seeAllButton;

@end

@implementation SSOTopPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)initializeData {
    [super initializeData];
    self.topView = [UIView new];
    self.titleLabel = [UILabel new];
    self.titleLabel.text = NSLocalizedString(@"fan-page.top-photos.title-label", @"Top 10 title");
    self.seeAllButton = [SSOUSnapLightButton new];
    [self.seeAllButton setTitle:NSLocalizedString(@"fan-page.see-all-button", @"See all button title") forState:UIControlStateNormal];
    self.provider.delegate = self;
    [self.seeAllButton addTarget:self action:@selector(seeAllTopSnapsAction) forControlEvents:UIControlEventTouchUpInside];
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
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);

    // Overide the collectionView flow from superClass and set the desired spacing.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    self.collectionView.collectionViewLayout = flowLayout;

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
      make.left.and.right.and.bottom.equalTo(self.view);
      make.top.equalTo(self.topView.mas_bottom);
    }];

    self.titleLabel.font = [SSOThemeHelper avenirLightFontWithSize:19];
    self.seeAllButton.titleLabel.font = [SSOThemeHelper avenirLightFontWithSize:14];
}

#pragma mark - Getter

- (CGSize)cellSize {
    CGFloat cellWidth = self.collectionView.frame.size.height - kTopPhotosCellTextHeight;
    return CGSizeMake(cellWidth, self.collectionView.frame.size.height);
}

#pragma mark - IBActions

/**
 *  Action of the button See All
 */

- (void)seeAllTopSnapsAction {
    SSOSnapViewController *snapVC = [SSOSnapViewController new];
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
