//
//  SSOLoginRegisterProtocol.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SSOLoginRegisterDelegate

@optional

/**
 *  Method called after the user pushed validate on login
 *
 *  @param info dictionary containing email and password
 */
- (void)didLoginWithInfo:(NSDictionary *)info;

/**
 *  Method called after the user pushed validate on register
 *
 *  @param info dictionary containing email and password
 *  @param meta dictionary containing birthday, username, etc..
 */
- (void)didRegisterWithInfo:(NSDictionary *)info andMeta:(NSDictionary *)meta;

/**
 *  EditMediaVC needs a return when the user finished to log in in order to push the next VC
 */
- (void)didFinishAuthProcess;
@end
