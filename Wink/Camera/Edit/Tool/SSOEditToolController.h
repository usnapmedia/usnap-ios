//
//  SSOEditTool.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOAnimatableView.h"
#import "SSOEditViewControllerProtocol.h"


@protocol SSOEditToolDelegate;

/**
 *  Used to have the selector methods for the button
 */
@protocol SSOEditToolProtocol <NSObject>

/**
 *  Display the container views
 *
 *  @param animated if animated
 */
- (void)displayContainerViews:(BOOL)animated;

/**
 *  Hide the container views
 *
 *  @param animated if animated
 */
- (void)hideContainerViews:(BOOL)animated;

@end

/**
 *  Abstract class, should not be instanciated
 */
@interface SSOEditToolController : UIViewController <SSOEditToolProtocol>

@property(weak, nonatomic) id<SSOEditToolDelegate> delegate;

// Animatable view from the parent
@property(weak, nonatomic) UIView<SSOAnimatableView> *subtoolView;
@property(weak, nonatomic) UIView<SSOAnimatableView> *accessoryView;
@property(weak, nonatomic) UIView<SSOAnimatableView> *buttonsView;
@property(weak, nonatomic) UIView<SSOAnimatableView> *bottomView;


@end

@protocol SSOEditToolDelegate <NSObject>

- (void)editToolWillBeginEditing:(SSOEditToolController *)tool;

- (void)editToolWillEndEditing:(SSOEditToolController *)tool;

@end
