//
//  SSOSimpleCollectionViewProvider.m
//  SSOBaseProvider
//
//  Created by Gabriel Cartier on 2015-04-21.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSimpleCollectionViewProvider.h"
#import "SSBaseViewCellProtocol.h"

@implementation SSOSimpleCollectionViewProvider

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.inputData count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell<SSBaseViewCellProtocol> *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReusableIdentifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(configureCell:)]) {
        [cell configureCell:[self.inputData objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Send message to the delegate if the method is implemented
    if ([self.delegate respondsToSelector:@selector(provider:didSelectRowAtIndexPath:)]) {
        [self.delegate provider:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Send message to the delegate if the method is implemented
    if ([self.delegate respondsToSelector:@selector(provider:didDeselectRowAtIndexPath:)]) {
        [self.delegate provider:self didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSLog(@"cell did appear %f", cell.frame.size.width);
    if ([cell respondsToSelector:@selector(willDisplayCell:)]) {
        UICollectionViewCell<SSBaseViewCellProtocol> *cellProtocol = (UICollectionViewCell<SSBaseViewCellProtocol> *)cell;
        [cellProtocol willDisplayCell:[self.inputData objectAtIndex:indexPath.row]];
    }
    
}
@end
