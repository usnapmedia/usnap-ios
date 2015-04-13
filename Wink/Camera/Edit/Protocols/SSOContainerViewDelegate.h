//
//  SSOButtonsContainerViewProtocol.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSOContainerViewDelegate <NSObject>

@optional

/**
 *  Called when the done button is pressed on a container view
 *
 *  @param view the view it is called from
 */
- (void)containerViewDoneButtonPressed:(UIView *)view;

/**
 *  Called when the cancel button is pressed on a container view
 *
 *  @param view the view it is called from
 */
- (void)containerViewCancelButtonPressed:(UIView *)view;

@end