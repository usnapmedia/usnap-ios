//
//  WKSocialNetworkHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "WKSocialNetworkHelper.h"
#import <TwitterKit/TwitterKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation WKSocialNetworkHelper

/**
 *  Connect the user to social networks by changing the value of the switchers in settings
 *
 *  @param socialNetwork the social network to connect
 *  @param theSwitch     the switch changed
 */
+ (void)manageConnectionToSocialNetwork:(NSString *)socialNetwork withSwitch:(UISwitch *)theSwitch {

    // Twitter
    if ([socialNetwork isEqualToString:TWITTER_SWITCH_VALUE]) {
        if (theSwitch.on) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {

                if (session) {
                    [[NSUserDefaults standardUserDefaults] setObject:[session userName] forKey:TWITTER_ACCOUNT_NAME];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    [theSwitch setOn:theSwitch.on animated:YES];
                    NSLog(@"error is : %@", error);
                }
              }];
            });
        } else {
            [[Twitter sharedInstance] logOut];
        }
    } else if ([socialNetwork isEqualToString:FACEBOOK_SWITCH_VALUE]) {

        // TODO: FACEBOOK
    }
}

/**
 *  General method for Twitter. Will post the image
 *
 *  @param message the message to post
 *  @param image   the image to post
 */
+ (void)postTweetWithMessage:(NSString *)message andImage:(UIImage *)image {

    // If the user did not activate twitter in the app, it won't post anything on it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:TWITTER_SWITCH_VALUE]) {

        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        //  Before posting we could allow user to select the account he wants to use
        NSArray *arrayOfAccons = [accountStore accountsWithAccountType:accountType];
        ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
        for (ACAccount *acc in arrayOfAccons) {
            if ([acc.username isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:TWITTER_ACCOUNT_NAME]]) {
                account = acc;
            }
            [accountStore
                requestAccessToAccountsWithType:accountType
                                        options:nil
                                     completion:^(BOOL granted, NSError *error) {

                                       if (granted == YES) {
                                           // Check if there is an image to upload (even if there should always be one...)
                                           if (image) {
                                               NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);

                                               // 1st step is to send the image on Twitter servers
                                               [self postImageToTwitter:imageData
                                                             withAccount:account
                                                   withCompletionHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                     // Make a dic from the response
                                                     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                                                     // Get the media_id number from the dic and transform it into a string
                                                     NSString *media_id_str = [[dic valueForKey:@"media_id"] stringValue];
                                                     // Check if the response is good, then if it is send
                                                     if ([urlResponse statusCode] == 200) {
                                                         // If we got a success for the image we can then post the tweet
                                                         [self postTweetWithMessage:message
                                                                          onAccount:account
                                                                         andIdImage:media_id_str
                                                              withCompletionHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                                // Handle the errors
                                                                if ([urlResponse statusCode] == 200) {
                                                                    // Tweet has been uploaded
                                                                } else {
                                                                    NSLog(@"Error uploading tweet with error : %@", error);
                                                                }

                                                              }];

                                                     } else {
                                                         NSLog(@"Error uploading photo to Twitter with error : %@", error);
                                                     }

                                                   }];
                                           }
                                       }
                                     }];
        }
    }
}

/**
 *  Final method for Twitter to post the tweet after the image has been sent to the server
 *
 *  @param message  the message
 *  @param account  the user account
 *  @param media_id the id of the photo on twitter servers
 *  @param handler  completion handler
 */
+ (void)postTweetWithMessage:(NSString *)message
                   onAccount:(ACAccount *)account
                  andIdImage:(NSString *)media_id
       withCompletionHandler:(SLRequestHandler)handler {

    // Make a dic to pass parameters to the request
    NSDictionary *dicTweet = [[NSDictionary alloc] initWithObjectsAndKeys:message, @"status", media_id, @"media_ids", nil];
    // Init the request to upload the tweet with it's picture and text
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:[NSURL URLWithString:TWITTER_TWEET_UPLOAD_URL]
                                                   parameters:dicTweet];
    // Set the account to use for the request
    [postRequest setAccount:account];

    [postRequest performRequestWithHandler:handler];
}

/**
 *  1st step method. Post the image to twitter servers
 *
 *  @param imageData the JPEGRepresentation of the image
 *  @param account   the user account
 *  @param handler   the completion handler
 */
+ (void)postImageToTwitter:(NSData *)imageData withAccount:(ACAccount *)account withCompletionHandler:(SLRequestHandler)handler {
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:[NSURL URLWithString:TWITTER_MEDIA_UPLOAD_URL]
                                                   parameters:nil];
    // Set the account to use for the request
    [postRequest setAccount:account];
    // Divide the request into multipart to upload the image
    [postRequest addMultipartData:imageData withName:@"media" type:@"image/jpeg" filename:@"image.jpg"];

    [postRequest performRequestWithHandler:handler];
}

@end