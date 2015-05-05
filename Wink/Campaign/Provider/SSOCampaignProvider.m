//
//  SSOCampaignProvider.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-24.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignProvider.h"

@interface SSOCampaignProvider () <UICollectionViewDelegateFlowLayout>

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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate provider:self willDisplayCell:cell forItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

@end
