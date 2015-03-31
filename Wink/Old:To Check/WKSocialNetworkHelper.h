//
//  WKSocialNetworkHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKSocialNetworkHelper : NSObject

/**
 *  Connect the user to social networks by changing the value of the switchers in settings
 *
 *  @param socialNetwork the social network to connect
 *  @param theSwitch     the switch changed
 */
+ (void)manageConnectionToSocialNetwork:(NSString *)socialNetwork withSwitch:(UISwitch *)theSwitch;

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

@end
