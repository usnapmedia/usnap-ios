//
//  SSOFeedViewController.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOCustomCellSizeCollectionViewProvider.h"

@interface SSOFeedViewController : UIViewController

@property(strong, nonatomic, readonly) UICollectionView *collectionView;
@property(strong, nonatomic, readonly) SSOCustomCellSizeCollectionViewProvider *provider;

#pragma mark - Initialization

/**
 *  Initialize the data of the VC
 */
- (void)initializeData;

#pragma mark - Setters

/**
 *  Set the data for the controller to display
 *
 *  @param data       the data
 *  @param cellNib    the nib name for the cell
 *  @param reusableID the reusable ID
 */
- (void)setData:(NSArray *)data withCellNib:(NSString *)cellNib andCellReusableIdentifier:(NSString *)reusableID;

#pragma mark - Animations

/**
 *  Display the loading overlay view
 */
- (void)displayLoadingOverlay;

/**
 *  Hide the loading overlay view
 */
- (void)hideLoadingOverlay;

/**
 *  Returns the size of the cell
 *
 *  @return the cell size
 */
- (CGSize)cellSize;

@end
