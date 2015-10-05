//
//  SSOPhotoDetailViewController.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOSnap.h"
#import "SSODynamicCellSizeCollectionViewProvider.h"

@interface SSOPhotoDetailViewController : UIViewController <UIScrollViewDelegate>

- (instancetype)initWithSnap:(SSOSnap *)snap andInputData:(NSMutableArray*)inputData;

@end
