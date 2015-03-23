//
//  SSOGooglePlusHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "SSOSocialNetworkAPI.h"

@interface SSOGooglePlusHelper : NSObject <GPPSignInDelegate>

- (void)trySilentAuthentication;

+ (instancetype)sharedInstance;
- (void)signIn;
- (void)signOut;
- (void)disconnect;

@end
