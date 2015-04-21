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
 */
- (void)usnapConnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork;

/**
 *  Disconnect from social network
 *
 *  @param socialNetwork the network
 */
- (void)usnapDisconnectToSocialNetwork:(SelectedSocialNetwork)socialNetwork;

@end
