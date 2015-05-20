//
//  SSODrawAccessoryContainerView.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOContainerViewDelegate.h"

@protocol SSODrawContainerViewDelegate;

@interface SSODrawAccessoryContainerView : UIView

@property(weak, nonatomic) IBOutlet UIView *viewFivePoints;
@property(weak, nonatomic) id<SSODrawContainerViewDelegate> delegate;

@end

@protocol SSODrawContainerViewDelegate <SSOContainerViewDelegate>

/**
 *  Called when the size buttons are pressed to change draw line size
 *
 *  @param view     the view it is called from
 *  @param lineSize the size of the line
 */
- (void)drawContainer:(UIView *)view didChangePointSize:(CGFloat)lineSize withButtonView:(UIView *)buttonView;
@end