//
//  SSOEditViewControllerProtocol.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ACEDrawingView.h>
#import "SSOEditMediaMovableTextView.h"
#import "SSOAnimatableView.h"
#import "SSOAdjustementsHelper.h"

@protocol SSOEditViewControllerProtocol <NSObject>

#pragma mark - Tools view

/**
 *  Get the draw view to write on
 *
 *  @return the draw view
 */
- (ACEDrawingView *)drawView;

/**
 *  Get the text view to edit and move
 *
 *  @return the text view
 */
- (SSOEditMediaMovableTextView *)textView;

/**
 *  Get the image view to apply filters on it
 *
 *  @return the image view
 */
- (UIImageView *)imageView;

/**
 *  Get the adjustment helper
 *
 *  @return the helper
 */
- (SSOAdjustementsHelper *)adjustmentHelper;

#pragma mark - Container view

/**
 *  Get the view containing the sub tools if any
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)subtoolContainerView;

/**
 *  Get the view containing the accessory for the tools if any. i.e. the sliders
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)accessoryContainerView;

/**
 *  Get the view containing the buttons for actions for the tools if any. i.e. the undo button
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)buttonsContainerView;

/**
 *  The bottom view containing all the tool buttons. This is mainly used to animate the VC
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)bottomView;

/**
 *  The top view containing the control (back, close). This is mainly used to animate the VC
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)topView;

@end