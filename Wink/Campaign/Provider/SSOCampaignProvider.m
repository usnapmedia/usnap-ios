//
//  SSOCampaignProvider.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-24.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignProvider.h"

@interface SSOCampaignProvider () <UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property(weak, nonatomic) UICollectionView *tabCollectionView;

@end

@implementation SSOCampaignProvider
// Delegate is redefined
@dynamic delegate;

- (instancetype)initWithTabCollectionView:(UICollectionView *)tabCollectionView

                             andInputData:(NSMutableArray *)inputData {

    if (self = [super init]) {

        self.inputData = inputData;
        self.tabCollectionView = tabCollectionView;
    }

    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

/**
 *  ScrollView
 *
 *  @param scrollView          scrollView
 *  @param velocity            velocity
 *  @param targetContentOffset targetContentOffset
 */

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.delegate providerWillEndDragging:self scrollView:scrollView targetContentOffset:targetContentOffset];
}

@end
