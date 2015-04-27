//
//  SSORectangleSocialButton.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOSocialNetworkAPI.h"

@interface SSORectangleSocialButton : UIButton

@property(nonatomic, readonly) SelectedSocialNetwork socialNetwork;

- (instancetype)initWithSocialNetwork:(SelectedSocialNetwork)socialNetwork state:(BOOL)connected;

- (void)setState:(BOOL)connected forSocialNetwork:(SelectedSocialNetwork)socialNetwork;

@end
