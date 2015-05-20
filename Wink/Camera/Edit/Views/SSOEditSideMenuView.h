//
//  SSOEditSideMenuView.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-06.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOFadingContainerView.h"

@protocol SideMenuDelegate;

@interface SSOEditSideMenuView : SSOFadingContainerView

@property(strong, nonatomic) NSArray *arrayButtons;

@property(nonatomic) float heightOfVC;
@property(nonatomic) float widthOfVC;

- (void)setSizeOfView:(CGSize)sizeOfView;

/**
 *  Setup the UI
 */
- (void)setupUI;

@end

@protocol SideMenuDelegate

@end
