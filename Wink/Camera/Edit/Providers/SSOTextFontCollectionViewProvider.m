//
//  SSOTextFontCollectionViewProvider.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTextFontCollectionViewProvider.h"

NSString *const kFontCellReusableIdentifier = @"fontCollectionViewCellIdentifier";

@implementation SSOTextFontCollectionViewProvider

#pragma mark - Initialization

- (instancetype)initWithDefaultData {
    if (self = [super init]) {
        [self generateDefaultData];
    }
    return self;
}

/**
 *  Initialize default data for the font cells
 */
- (void)generateDefaultData {
    self.cellReusableIdentifier = kFontCellReusableIdentifier;
    self.inputData = [[NSMutableArray alloc] initWithArray:@[
        @{ @"font_name" : @"Georgia" },
        @{ @"font_name" : @"HelveticaNeue" },
        @{ @"font_name" : @"Futura" },

    ]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

@end
