//
//  SSOTopPhotosViewController.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTopPhotosViewController.h"
#import "SSOCustomCellSizeCollectionViewProvider.h"
#import "SSOUSnapButton.h"
#import "SSOGrayBackgroundWithBorderView.h"
#import "SSOSnapViewController.h"
#import "SSOFanPageViewController.h"
#import <Masonry.h>
#import "SSOPhotoDetailViewController.h"
#import "SSOThemeHelper.h"

NSInteger const kTopPhotosCellWidth = 100;
NSInteger const kTopPhotosCellOffset = 5;

@interface SSOTopPhotosViewController () <SSOProviderDelegate>

@property(strong, nonatomic) SSOGrayBackgroundWithBorderView *topView;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) SSOUSnapButton *seeAllButton;

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
    self.topView = [SSOGrayBackgroundWithBorderView new];
    self.titleLabel = [UILabel new];
    self.titleLabel.text = [NSLocalizedString(@"fan-page.top-photos.title-label", @"Top 10 title") uppercaseString];
    self.seeAllButton = [SSOUSnapButton new];
    [self.seeAllButton setTitle:[NSLocalizedString(@"fan-page.see-all-button", @"See all button title") uppercaseString] forState:UIControlStateNormal];
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
      make.left.equalTo(self.topView).with.offset(kConstraintOffset);
      make.right.equalTo(self.seeAllButton.mas_left).with.offset(-kConstraintOffset);

    }];

    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.topView.mas_bottom).with.offset(-5);
      make.right.equalTo(self.topView).with.offset(-kConstraintOffset);
      make.width.equalTo([NSNumber numberWithInteger:kButtonWidthConstraint]);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.and.right.and.bottom.equalTo(self.view);
      make.top.equalTo(self.topView.mas_bottom);
    }];

    self.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:17];
    self.seeAllButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:10];
}

#pragma mark - Getter

- (CGSize)cellSize {
    return CGSizeMake(kTopPhotosCellWidth, self.collectionView.frame.size.height - kTopPhotosCellOffset);
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