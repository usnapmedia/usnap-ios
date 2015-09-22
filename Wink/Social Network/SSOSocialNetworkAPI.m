//
//  SSOSocialNetworkAPI.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSocialNetworkAPI.h"
#import <TwitterKit/TwitterKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Crashlytics/Crashlytics.h>
#import <GooglePlus.h>
#import "SSOGooglePlusHelper.h"
#import "SSFacebookHelper.h"
#import "FBSDKProfile.h"
#import "FBSDKAccessToken.h"

@implementation SSOSocialNetworkAPI

#pragma mark - Utilities

/**
 * @Override
 * Singleton class
 */
+ (SSOSocialNetworkAPI *)sharedInstance {
    static SSOSocialNetworkAPI *wkSocialNetworkHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      wkSocialNetworkHelper = [[self alloc] init];
    });
    return wkSocialNetworkHelper;
}

- (void)loginWithSocialFramework:(SelectedSocialNetwork)socialNetwork {

    if (socialNetwork == facebookSocialNetwork) {
        [SSFacebookHelper loginWithPermissions:self.facebookPermissions
            onSuccess:^(FBSDKLoginManagerLoginResult *result) {
              [self.delegate socialNetwork:facebookSocialNetwork DidFinishLoginWithError:nil];

            }
            onFailure:^(NSError *error) {
              [self.delegate socialNetwork:facebookSocialNetwork DidFinishLoginWithError:error];

              CLS_LOG(@"error FB login :%@", error);
            }
            onCancellation:^{
              [self.delegate socialNetwork:facebookSocialNetwork DidCancelLogin:nil];

            }];

    } else if (socialNetwork == twitterSocialNetwork) {

        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {

          if (session) {
              [self.delegate socialNetwork:twitterSocialNetwork DidFinishLoginWithError:error];
              // Saving the account name in case we want to post directly to Twitter
              [[NSUserDefaults standardUserDefaults] setObject:[session userName] forKey:kTwitterAccountName];
              [[NSUserDefaults standardUserDefaults] synchronize];
          } else {
              CLS_LOG(@"error is : %@", error);
              // Check if the user cancelled the login
              if (error.code == 1) {
                  [self.delegate socialNetwork:twitterSocialNetwork DidCancelLogin:error];
              }
          }
        }];

    } else if (socialNetwork == googleSocialNetwork) {

        [[SSOGooglePlusHelper sharedInstance] signIn];
    }
}

- (void)logoutFromSocialFramework:(SelectedSocialNetwork)socialNetwork {

    if (socialNetwork == facebookSocialNetwork) {
        
        if([FBSDKAccessToken currentAccessToken] != nil) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions" parameters:nil tokenString:[FBSDKAccessToken currentAccessToken].tokenString version:@"v2.0" HTTPMethod:@"DELETE"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                NSLog(@"Test... : %@", error);
            }];
        }
        [SSFacebookHelper logout];
    }

    else if (socialNetwork == twitterSocialNetwork) {

        [[Twitter sharedInstance] logOut];

    }

    else if (socialNetwork == googleSocialNetwork) {
        [[SSOGooglePlusHelper sharedInstance] disconnect];
    }
}

#pragma mark - Connection checks

- (BOOL)isConnectedToSocialNetwork:(SelectedSocialNetwork)network {

    switch (network) {
    case facebookSocialNetwork:
        return [self isFacebookConnected];
        break;

    case twitterSocialNetwork:
        return [self isTwitterConnected];
        break;

    case googleSocialNetwork:
        return [self isGoogleConnected];
        break;

    default:
        break;
    }
}

/**
 *  Check if the user is connected to facebook
 *
 *  @return a BOOL
 */
- (BOOL)isFacebookConnected {

    return [SSFacebookHelper isConnected];
}

/**
 *  Check if the user is connected to twitter
 *
 *  @return a BOOL
 */
- (BOOL)isTwitterConnected {

    if ([[Twitter sharedInstance] session]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  Check if the user is connected to google
 *
 *  @return a BOOL
 */
- (BOOL)isGoogleConnected {

    return [[SSOGooglePlusHelper sharedInstance] isConnected];
}

#pragma mark - Session informations

- (NSString *)facebookToken {

    return [FBSDKAccessToken currentAccessToken].tokenString;
}

- (NSString *)googleToken {

    return [[SSOGooglePlusHelper sharedInstance] getAccessToken];
}

- (NSString *)twitterToken {

    return [[Twitter sharedInstance] session].authToken;
}

- (NSString *)twitterSecret {

    return [[Twitter sharedInstance] session].authTokenSecret;
}

// TODO: this should be moved in Facebook helper
#pragma mark - Facebook

/**
 *  Post an image and a text on Facebook
 *
 *  @param message     the message
 *  @param imageToPost the image
 */
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

/**
 *  Post a video to facebook with a message
 *
 *  @param message     the message
 *  @param videoToPost the video
 */
+ (void)postVideoToFacebookWithMessage:(NSString *)message andVideo:(NSData *)videoToPost {

    NSMutableDictionary *paramsVideo = [NSMutableDictionary dictionaryWithObjectsAndKeys:videoToPost, @"video.mov", message, @"description", nil];
}

// TODO: This should be moved in a Twitter helper
#pragma mark - Twitter

/**
 *  Combines methods to post image then tweet it
 *
 *  @param message the message body
 *  @param image   the image
 */
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

    [accountStore requestAccessToAccountsWithType:accountType
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
