//
//  SSOGooglePlusHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOGooglePlusHelper.h"

@implementation SSOGooglePlusHelper

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];
      [GPPDeepLink setDelegate:sharedInstance];
      [GPPDeepLink readDeepLinkAfterInstall];
      GPPSignIn *signIn = [GPPSignIn sharedInstance];
      signIn.shouldFetchGooglePlusUser = YES;
      signIn.scopes = @[ kGTLAuthScopePlusLogin ];
      signIn.clientID = kGoogleClientId;
      signIn.delegate = sharedInstance;
      [[GPPShare sharedInstance] setDelegate:sharedInstance];

    });
    return sharedInstance;
}

#pragma mark - Google methods

- (void)signIn {
    if ([GPPSignIn sharedInstance].clientID == nil) {
        NSLog(@"No Client ID is set");
        return;
    }
    [[GPPSignIn sharedInstance] authenticate];
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)trySilentAuthentication {

    [[GPPSignIn sharedInstance] trySilentAuthentication];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {

    if (error) {
        [[GPPSignIn sharedInstance] signOut];
    }
    [[SSOSocialNetworkAPI sharedInstance].delegate socialNetwork:googleSocialNetwork DidFinishLoginWithError:error];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
    [[SSOSocialNetworkAPI sharedInstance].delegate socialNetwork:googleSocialNetwork DidFinishLogoutWithError:error];
}

@end
