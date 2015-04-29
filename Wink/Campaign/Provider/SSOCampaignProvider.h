//
//  SSOCampaignProvider.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-24.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSimpleCollectionViewProvider.h"

@protocol SSOCampaignProviderDelegate <SSOProviderDelegate>

/**
 *  Delegate method called when the provider will display a new cell
 *
 *  @param provider  the provider
 *  @param cell      the new cell
 *  @param indexPath the indexPath
 */
- (void)provider:(id)provider willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SSOCampaignProvider : SSOSimpleCollectionViewProvider

@property(weak, nonatomic) id<SSOCampaignProviderDelegate> delegate;

/**
 *  Initialization method
 *
 *  @param tabCollectionView   the collectionView
 *  @param inputData           the array of data
 *
 *  @return the provider
 */
- (instancetype)initWithTabCollectionView:(UICollectionView *)tabCollectionView andInputData:(NSMutableArray *)inputData;

@end
