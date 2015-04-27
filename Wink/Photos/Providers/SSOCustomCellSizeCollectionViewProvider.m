//
//  SSOTopPhotosCollectionViewProvider.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCustomCellSizeCollectionViewProvider.h"
#import "SSOFeedViewController.h"

@implementation SSOCustomCellSizeCollectionViewProvider

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.parentVC respondsToSelector:@selector(cellSize)]) {
        return [(SSOFeedViewController *)self.parentVC cellSize];
    }
    // Else return base size
    return [(UICollectionViewFlowLayout *)collectionViewLayout itemSize];
}

@end
