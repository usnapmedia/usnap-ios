//
//  SSOLoginContainerView.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOLoginRegisterDelegate.h"

@interface SSOLoginContainerView : UIView<SSOLoginRegisterDelegate>

@property(weak, nonatomic) id<SSOLoginRegisterDelegate> delegate;

- (void)setupViewForAnimation;
@end
