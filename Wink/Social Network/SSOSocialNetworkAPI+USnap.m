//
//  SSOSocialNetworkAPI+USnap.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSocialNetworkAPI+USnap.h"
#import "FBSDKAccessToken.h"

@implementation SSOSocialNetworkAPI (USnap)

- (BOOL)usnapConnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork {

    if ([self isConnectedToSocialNetwork:socialNetwork]) {
        [self setNSUserDefaultWithValue:YES andSocialNetwork:socialNetwork];
        return YES;
    } else {
        [self loginWithSocialFramework:socialNetwork];
        [self setNSUserDefaultWithValue:YES andSocialNetwork:socialNetwork];
        return NO;
    }
}

- (void)usnapDisconnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork {

    [self setNSUserDefaultWithValue:NO andSocialNetwork:socialNetwork];
}

- (BOOL)isUsnapConnectedToSocialNetwork:(SelectedSocialNetwork)socialNetwork {
    NSString *key;

    switch (socialNetwork) {
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
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
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

    // Save the status
    [[NSUserDefaults standardUserDefaults] setBool:connectedValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)connectedSocialNetworkAPIParameters {
    NSMutableDictionary *paramDictionary = [NSMutableDictionary new];

    // I do a double check on each social network. 1st check is for the value in userDefault, 2nd is check the session or token. If the
    if ([self isUsnapConnectedToSocialNetwork:facebookSocialNetwork]) {
        if ([self isConnectedToSocialNetwork:facebookSocialNetwork]) {
            [paramDictionary setObject:[self facebookToken] forKey:@"fb"];
        } else {
            [self usnapDisconnectToSocialNetwork:facebookSocialNetwork];
        }
    }
    if ([self isUsnapConnectedToSocialNetwork:twitterSocialNetwork]) {
        if ([self isConnectedToSocialNetwork:twitterSocialNetwork]) {
            [paramDictionary setObject:[self twitterToken] forKey:@"tw_key"];
            [paramDictionary setObject:[self twitterSecret] forKey:@"tw_secret"];
        } else {
            [self usnapDisconnectToSocialNetwork:twitterSocialNetwork];
        }
    }
    if ([self isUsnapConnectedToSocialNetwork:googleSocialNetwork]) {
        if ([self isConnectedToSocialNetwork:googleSocialNetwork]) {
            [paramDictionary setObject:[self googleToken] forKey:@"gp"];
        } else {
            [self usnapDisconnectToSocialNetwork:googleSocialNetwork];
        }
    }
    return paramDictionary.copy;
}

@end
