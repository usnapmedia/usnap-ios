//
//  SSOViewControllerWithLiveFeed.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisplayFanPageFromCamera <NSObject>

- (void)userDidDismissCamera;

@end

@interface SSOViewControllerWithLiveFeed : UIViewController

@property(strong, nonatomic) UIView *feedContainerView;
@property (weak, nonatomic) id <DisplayFanPageFromCamera> displayFanPageDelegate;

@end
