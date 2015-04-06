//
//  SSBaseCollectionView.m
//  Kwirk
//
//  Created by Justin Khan on 2014-08-11.
//  Copyright (c) 2014 Kwirk Software Inc. All rights reserved.
//

#import "SSBaseCollectionView.h"
#import "SSBaseViewCellProtocol.h"
#import "SSCellViewSection.h"
#import "SSCellViewItem.h"

@interface SSBaseCollectionView ()

@end

@implementation SSBaseCollectionView

- (void)awakeFromNib {
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark - UICollectionView Data Source

/**
 *  Number of sections for the collection view
 *
 *  @return Number of sections
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.inputData count];
}

/**
 *  Number of rows for each section for the collection view
 *
 *  @return Number of rows
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    SSCellViewSection *cellViewSection = (SSCellViewSection *)[self.inputData objectAtIndex:section];
    NSArray *sectionArray = cellViewSection.rows;

    return [sectionArray count];
}

#pragma mark - UICollectionView Delegate

/**
 *  Populate collection view with cells. Configure cells
 *  @return Cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCellViewSection *collectionViewSection = (SSCellViewSection *)[self.inputData objectAtIndex:indexPath.section];
    SSCellViewItem *collectionViewItem = [collectionViewSection.rows objectAtIndex:indexPath.row];

    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewItem.cellReusableIdentifier forIndexPath:indexPath];
    [cell configureCell:collectionViewItem.objectData];

    return cell;
}

#pragma mark - Utilities
- (id)objectDataAtIndexPath:(NSIndexPath *)indexPath {
    //@FIXME: this is because we don't use sections
    SSCellViewSection *collectionViewSection = (SSCellViewSection *)[self.inputData objectAtIndex:indexPath.section];
    SSCellViewItem *collectionViewItem = [collectionViewSection.rows objectAtIndex:indexPath.row];
    return collectionViewItem.objectData;
}

@end
