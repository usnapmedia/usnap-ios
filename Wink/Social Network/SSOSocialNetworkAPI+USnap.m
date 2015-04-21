//
//  SSOSocialNetworkAPI+USnap.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSocialNetworkAPI+USnap.h"

@implementation SSOSocialNetworkAPI (USnap)

- (void)usnapConnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork {

    if ([self isConnectedToSocialNetwork:socialNetwork]) {
        [self setNSUserDefaultWithValue:YES andSocialNetwork:socialNetwork];
    }
    else {
        
        [self loginWithSocialFramework:socialNetwork];
        [self setNSUserDefaultWithValue:YES andSocialNetwork:socialNetwork];

    }
}

- (void)usnapDisconnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork {

    [self setNSUserDefaultWithValue:NO andSocialNetwork:socialNetwork];
}

/**
 *  Save the socialNetwork switch connection status
 *
 *  @param connectedValue the BOOL value to save
 *  @param network        the social network
 */
- (void)setNSUserDefaultWithValue:(BOOL)connectedValue andSocialNetwork:(SelectedSocialNetwork)network {

    NSString *key;

    switch (network) {
    case facebookSocialNetwork:
        key = kFacebookSelected;
        break;

    case twitterSocialNetwork:
        key = kTwitterSelected;
        break;

    case googleSocialNetwork:
        key = kGoogleSelected;
        break;

    default:
        break;
    }

    [[NSUserDefaults standardUserDefaults] setBool:connectedValue forKey:key];
}

@end
