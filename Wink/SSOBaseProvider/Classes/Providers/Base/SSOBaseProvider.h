//
//  SSOBaseProvider.h
//  SSOBaseProvider
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSCellViewItem.h"
#import "SSCellViewSection.h"
#import "SSBaseViewCellProtocol.h"
#import "SSOProviderDelegate.h"

@interface SSOBaseProvider : NSObject

@property(weak, nonatomic) NSMutableArray *inputData;
@property(weak, nonatomic) id<SSOProviderDelegate> delegate;

/**
 *  Get the object data from an index path. This will get the object data of an item
 *
 *  @param indexPath the index path
 *
 *  @return the object
 */
- (id)objectDataAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Get the cell view item from an index path. This will get the cell view item
 *
 *  @param indexPath the index path
 *
 *  @return the cell view item
 */
- (SSCellViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Get the index path for a specific object
 *
 *  @param object the object
 *
 *  @return the index path of the object
 */
- (NSIndexPath *)indexPathForObject:(id)object;

@end
