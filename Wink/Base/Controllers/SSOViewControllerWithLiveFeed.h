//
//  SSOViewControllerWithLiveFeed.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This protocol allows the user to go to the fan page when he click at the collection view
 */

@protocol DisplayFanPageFromCamera <NSObject>

- (void)userDidDismissCamera;

@end

@interface SSOViewControllerWithLiveFeed : UIViewController

@property(strong, nonatomic) UIView *feedContainerView;
@property (weak, nonatomic) id <DisplayFanPageFromCamera> displayFanPageDelegate;

@end
