//
//  SSOLoginRegisterProtocol.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@protocol SSOLoginRegisterDelegate

//@required

@optional

- (void)didLoginWithInfo:(NSDictionary *)info;

- (void)didRegisterWithInfo:(NSDictionary *)info andMeta:(NSDictionary *)meta;

- (void)didFinishAuthProcess;
@end
