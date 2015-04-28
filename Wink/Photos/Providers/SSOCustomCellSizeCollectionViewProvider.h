//
//  SSOTopPhotosCollectionViewProvider.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSimpleCollectionViewProvider.h"

@interface SSOCustomCellSizeCollectionViewProvider : SSOSimpleCollectionViewProvider <UICollectionViewDelegateFlowLayout>

//@TODO There should be a protocol
@property(weak) UIViewController *parentVC;

@end
