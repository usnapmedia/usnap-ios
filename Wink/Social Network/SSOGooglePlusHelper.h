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

/**
 *  Return SSOGooglePlusHelper singleton instance
 *
 *  @return reference to the singleton
 */
+ (instancetype)sharedInstance;

/**
 *  Starts the authentication process. Set |attemptSSO| to try single sign-on.
 *  If |attemptSSO| is true, this method also tries to authenticate with a
 *  capable Google app, if installed.
 *  The delegate will be called at the end of this process.
 */
- (void)signIn;

/**
 *  Removes the OAuth 2.0 token from the keychain.
 */
- (void)signOut;

/**
 *  Disconnects the user from the app and revokes previous authentication.
 *  If the operation succeeds, the OAuth 2.0 token is also removed from keychain.
 *  The token is needed to disconnect so do not call |signOut| if |disconnect| is
 *  to be called.
 */
- (void)disconnect;

/**
 *  Get the token from Google Plus
 *
 *  @return idToken
 */
- (NSString *)getAccessToken;

/**
 *  Check if there is a user authenticated with google plus
 *
 *  @return <#return value description#>
 */
- (BOOL)isConnected;

@end
