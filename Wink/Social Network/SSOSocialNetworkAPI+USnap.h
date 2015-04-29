//
//  SSOSocialNetworkAPI+USnap.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSocialNetworkAPI.h"

@interface SSOSocialNetworkAPI (USnap)

/**
 *  Connect to social network
 *
 *  @param socialNetwork the network
 *
 *  @return YES if was already connected, NO otherwise
 */
- (BOOL)usnapConnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork;

/**
 *  Disconnect from social network
 *
 *  @param socialNetwork the network
 */
- (void)usnapDisconnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork;

/**
 *  Check the status of the social network based on the application. A user can be connected to a social network,
 *  while he chose not to share to it. This prevents tons of connection/disconnection to the numerous socials networks
 *
 *  @param socialNetwork the social network
 *
 *  @return YES if connected, NO otherwise
 */
- (BOOL)isUsnapConnectedToSocialNetwork:(SelectedSocialNetwork)socialNetwork;

/**
 *  Double check which social networks are connected. 1st with userDefault value, then with session. If there is no session just disconnect the social network
 *
 *  @return a dic containing the necessary session informations
 */
- (NSDictionary *)connectedSocialNetworkAPIParameters;

@end
