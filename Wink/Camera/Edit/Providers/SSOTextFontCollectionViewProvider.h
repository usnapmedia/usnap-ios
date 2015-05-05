//
//  SSOTextFontCollectionViewProvider.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <SSOSimpleCollectionViewProvider.h>

@interface SSOTextFontCollectionViewProvider : SSOSimpleCollectionViewProvider

@property(nonatomic) CGRect collectionViewFrame;

/**
*  Initialize the provider with the default data
*
*  @return the provider with default data
*/
- (instancetype)initWithDefaultData;

@end
