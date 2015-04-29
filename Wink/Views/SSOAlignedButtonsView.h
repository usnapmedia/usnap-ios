//
//  SSOAlignedButtonsView.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-19.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOFadingContainerView.h"

@interface SSOAlignedButtonsView : SSOFadingContainerView

- (void)setupViewforOrientation:(UIDeviceOrientation)orientation withArrayButtons:(NSArray *)arrayButtons;

@end
