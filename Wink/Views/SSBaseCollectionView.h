//
//  SSBaseCollectionView.h
//  Kwirk
//
//  Created by Justin Khan on 2014-08-11.
//  Copyright (c) 2014 Kwirk Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBaseViewCellProtocol.h"

@interface SSBaseCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

/**
 *  Input data into the collection view in the view controller that it's in
 *  Or you can set it in the prepareToSegue method in the previous view controller
 */
@property(strong, nonatomic) NSMutableArray *inputData;

/**
 *  Get the object data at the index path
 *
 *  @param indexPath The index path
 *
 *  @return The data
 */
- (id)objectDataAtIndexPath:(NSIndexPath *)indexPath;

@end
