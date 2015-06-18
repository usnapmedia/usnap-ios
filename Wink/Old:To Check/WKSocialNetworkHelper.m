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
#import <Crashlytics/Crashlytics.h>

@implementation WKSocialNetworkHelper

#pragma mark - Utilities

+ (void)manageConnectionToSocialNetwork:(NSString *)socialNetwork withSwitch:(UISwitch *)theSwitch {

    // Twitter
    if ([socialNetwork isEqualToString:kTwitterSwitchValue]) {
        if (theSwitch.on) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {

                    if (session) {
                        [[NSUserDefaults standardUserDefaults] setObject:[session userName] forKey:kTwitterAccountName];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    } else {
                        // Set the switch back to no
                        [theSwitch setOn:NO animated:YES];
                        NSLog(@"error is : %@", error);
                    }
                }];
            });
        } else {
            [[Twitter sharedInstance] logOut];
        }
    } else if ([socialNetwork isEqualToString:kFacebookSwitchValue]) {
        // Log the user in
        if (theSwitch.on) {

//            [SSFacebookHelper login:^(FBSDKLoginManagerLoginResult *result) {
//                CLS_LOG(@"Facebook connected");
//
//            } onFailure:^(NSError *error) {
//                // Set the switch back to no
//                [theSwitch setOn:NO animated:YES];
//                CLS_LOG(@"Facebook connection error: %@", error.description);
//
//            } onCancellation:^{
//
//            }];

        } else {
            // Logout
            [SSFacebookHelper logout];
        }
    }
}

#pragma mark - Facebook

+ (void)postImageToFacebookWithMessage:(NSString *)message andImage:(UIImage *)imageToPost {

    // If there is no image we should not be there so return
    if (!imageToPost) {
        return;
    }
    // Post to facebook
    // Post image to facebook
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:message forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(imageToPost) forKey:@"picture"];
}

+ (void)postVideoToFacebookWithMessage:(NSString *)message andVideo:(NSData *)videoToPost {
    NSMutableDictionary *paramsVideo = [NSMutableDictionary dictionaryWithObjectsAndKeys:videoToPost, @"video.mov", message, @"description", nil];
}

#pragma mark - Twitter

+ (void)postTweetWithMessage:(NSString *)message andImage:(UIImage *)image {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    //  Before posting we could allow user to select the account he wants to use
    NSArray *arrayOfAccons = [accountStore accountsWithAccountType:accountType];
    ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
    for (ACAccount *acc in arrayOfAccons) {
        if ([acc.username isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:kTwitterAccountName]]) {
            account = acc;
        }
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
                                                 // Check if the response is good, then if it is send
                                                 if ([urlResponse statusCode] == 200) {
                                                     // Make a dic from the response
                                                     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                                                     // Get the media_id number from the dic and transform it into a string
                                                     NSString *media_id_str = [[dic valueForKey:@"media_id"] stringValue];
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
                                                          URL:[NSURL URLWithString:kTwitterTweetUploadURL]
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
                                                          URL:[NSURL URLWithString:kTwitterMediaUploadURL]
                                                   parameters:nil];
    // Set the account to use for the request
    [postRequest setAccount:account];
    // Divide the request into multipart to upload the image
    [postRequest addMultipartData:imageData withName:@"media" type:@"image/jpeg" filename:@"image.jpg"];

    [postRequest performRequestWithHandler:handler];
}

@end
