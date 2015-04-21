//
//  SSOCustomSociaButton.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOSocialNetworkAPI.h"

@interface SSOCustomSocialButton : UIButton

@property(nonatomic, readonly) SelectedSocialNetwork socialNetwork;

- (instancetype)initWithSocialNetwork:(SelectedSocialNetwork)socialNetwork state:(BOOL)connected;
@end
