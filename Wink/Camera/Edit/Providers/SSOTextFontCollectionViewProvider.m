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
        self.inputData = [self generateDefaultData];
    }
    return self;
}

/**
 *  Initialize default data for the font cells
 *
 *  @return the default data
 */
- (NSMutableArray *)generateDefaultData {
    SSCellViewSection *section = [[SSCellViewSection alloc] init];

    SSCellViewItem *firstCellItem = [[SSCellViewItem alloc] init];
    firstCellItem.objectData = @{ @"font_name" : @"Arial" };
    firstCellItem.cellReusableIdentifier = kFontCellReusableIdentifier;
    // Add the items to the section
    [section.rows addObject:firstCellItem];

    firstCellItem = [[SSCellViewItem alloc] init];
    firstCellItem.objectData = @{ @"font_name" : @"Times" };
    firstCellItem.cellReusableIdentifier = kFontCellReusableIdentifier;
    // Add the items to the section
    [section.rows addObject:firstCellItem];

    firstCellItem = [[SSCellViewItem alloc] init];
    firstCellItem.objectData = @{ @"font_name" : @"Roboto" };
    firstCellItem.cellReusableIdentifier = kFontCellReusableIdentifier;
    // Add the items to the section
    [section.rows addObject:firstCellItem];

    return [@[ section ] mutableCopy];
}

@end
