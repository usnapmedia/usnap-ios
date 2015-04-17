//
//  SSOCameraViewController.h
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
// CollectionView imports
#import "SSBaseCollectionView.h"
#import "SSCellViewItem.h"
#import "SSCellViewSection.h"

@interface SSOCameraViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet SSBaseCollectionView *collectionView;

@end
