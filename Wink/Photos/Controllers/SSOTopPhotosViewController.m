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
#import <Masonry.h>

NSInteger const kTopPhotosCellWidth = 100;
NSInteger const kTopPhotosCellOffset = 10;
NSInteger const kTopViewHeightConstraint = 30;
NSInteger const kConstraintOffset = 10;
NSInteger const kButtonWidthConstraint = 60;

@interface SSOTopPhotosViewController ()

@property(strong, nonatomic) UIView *topView;
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
    self.topView = [UIView new];
    self.titleLabel = [UILabel new];
    self.titleLabel.text = [NSLocalizedString(@"fan-page.top-photos.title-label", @"Top 10 title") uppercaseString];
    self.seeAllButton = [SSOUSnapButton new];
    [self.seeAllButton setTitle:[NSLocalizedString(@"fan-page.see-all-button", @"See all button title") uppercaseString] forState:UIControlStateNormal];
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
      make.height.equalTo([NSNumber numberWithInt:kTopViewHeightConstraint]);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.topView);
      make.left.equalTo(self.topView).with.offset(kConstraintOffset);
      make.right.equalTo(self.seeAllButton.mas_left).with.offset(-kConstraintOffset);

    }];

    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.topView);
      make.right.equalTo(self.topView).with.offset(-kConstraintOffset);
      make.width.equalTo([NSNumber numberWithInt:kButtonWidthConstraint]);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.and.right.and.bottom.equalTo(self.view);
      make.top.equalTo(self.topView.mas_bottom);
    }];
}

#pragma mark - Getter

- (CGSize)cellSize {
    return CGSizeMake(kTopPhotosCellWidth, self.collectionView.frame.size.height - kTopPhotosCellOffset);
}

@end
