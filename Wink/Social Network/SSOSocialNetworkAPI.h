//
//  WKSocialNetworkHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SelectedSocialNetwork) {

    facebookSocialNetwork,
    twitterSocialNetwork,
    googleSocialNetwork

};

@protocol SocialNetworkDelegate;

@interface SSOSocialNetworkAPI : NSObject

@property(weak, nonatomic) id<SocialNetworkDelegate> delegate;

/**
 *  Return SSOSocialNetworkAPI singleton instance
 *
 *  @return reference to the singleton
 */
+ (SSOSocialNetworkAPI *)sharedInstance;

/**
 *  General method for Twitter. Will post the image
 *
 *  @param message the message to post
 *  @param image   the image to post
 */
+ (void)postTweetWithMessage:(NSString *)message andImage:(UIImage *)image;

/**
 *  Post an image on Facebook with a message
 *
 *  @param message     the message to post
 *  @param imageToPost  the image to post
 */
+ (void)postImageToFacebookWithMessage:(NSString *)message andImage:(UIImage *)imageToPost;

/**
 *  Post a video to Facebook with a message
 *
 *  @param message     the message to post
 *  @param videoToPost the video to post
 */
+ (void)postVideoToFacebookWithMessage:(NSString *)message andVideo:(NSData *)videoToPost;

/**
 *  Login the user to the specified social network
 *
 *  @param socialNetwork the social network
 */
- (void)loginWithSocialFramework:(SelectedSocialNetwork)socialNetwork;

/**
 *  Logout the user to the specified social network
 *
 *  @param socialNetwork the social network
 */
- (void)logoutFromSocialFramework:(SelectedSocialNetwork)socialNetwork;

/**
 *  Check if the user is connected to a social network
 *
 *  @param network the social network to check
 *
 *  @return YES if he is, No otherwise
 */
- (BOOL)isConnectedToSocialNetwork:(SelectedSocialNetwork)network;

@end

@protocol SocialNetworkDelegate

/**
 *  SocialNetworkDelegate method called when the social network's login response arrives.
 *
 *  @param socialNetwork the social network
 *  @param error         the error
 */
- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidFinishLoginWithError:(NSError *)error;

@optional

/**
 *  SocialNetwork method called when the user cancel login process
 *
 *  @param socialNetwork the social network
 *  @param error         the error
 */
- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidCancelLogin:(NSError *)error;

/**
 *  SocialNetworkDelegate method called when the social network's logout response arrives.
 *
 *  @param socialNetwork the social network
 *  @param error         the error
 */
- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidFinishLogoutWithError:(NSError *)error;

@end