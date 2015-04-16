//
//  SSOTextAccessoryContainerView.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOContainerViewDelegate.h"

@interface SSOTextAccessoryContainerView : UIView

@property(weak, nonatomic) IBOutlet UICollectionView *fontCollectionView;
@property(weak, nonatomic) id<SSOContainerViewDelegate> delegate;

@end
