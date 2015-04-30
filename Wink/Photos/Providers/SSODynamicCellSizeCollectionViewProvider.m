//
//  SSODynamicCellSizeCollectionViewProvider.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSODynamicCellSizeCollectionViewProvider.h"
#import "SSOSnap.h"

NSInteger const kNumberOfSmallCellsPerRow = 2.0f;
NSInteger const kCellSpacing = 2.5f;

@implementation SSODynamicCellSizeCollectionViewProvider

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellSizeHeightAtIndexPath:indexPath forCollectionView:collectionView];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellSpacing * 2;
}

#pragma mark - Dynamic size cells

/**
 *  Generate dynamic cell size based on the design
 *
 *  @param indexPath      the index path
 *  @param collectionView the collection view
 *
 *  @return the size of the cell
 */
- (CGSize)cellSizeHeightAtIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView {
    NSAssert([self.inputData objectAtIndex:indexPath.row], @"There should be an object at the index path");
    NSAssert([[self.inputData objectAtIndex:indexPath.row] isKindOfClass:[SSOSnap class]], @"Object should be of SSOSnap kind");
    SSOSnap *snap = (SSOSnap *)[self.inputData objectAtIndex:indexPath.row];

    // The width of a cell equals to the collection frame divided by the number of cells. We substract the spacing times the number of cells - 1 to get the
    // padding
    CGFloat smallCellWidth = (collectionView.frame.size.height / kNumberOfSmallCellsPerRow) - (kCellSpacing * (kNumberOfSmallCellsPerRow - 1));
    // Cell size has a ration of 1:1
    CGSize smallCellSize = CGSizeMake(smallCellWidth, smallCellWidth);
    // The size if based on the liked
    if ([snap.fbLikes integerValue] < 1) {
        return smallCellSize;
    } else { // Bigger cells are twice as big
        smallCellSize = CGSizeMake(smallCellWidth * 2, smallCellWidth * 2);
        return smallCellSize;
    }
}

@end
