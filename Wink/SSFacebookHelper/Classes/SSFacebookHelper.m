//
//  SSFacebookHelper.m
//
//  Created by Gabriel Cartier on 12/17/2013.
//  Copyright (c) 2013 Samsao. All rights reserved.
//

#import "SSFacebookHelper.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@implementation SSFacebookHelper

#pragma mark - Login Methods

+ (void)loginWithPermissions:(NSArray *)permissionsArray
                   onSuccess:(void (^)(FBSDKLoginManagerLoginResult *result))success
                   onFailure:(void (^)(NSError *error))failure
              onCancellation:(void (^)(void))cancellation {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

//    if ([FBSDKLoginUtility areAllPermissionsReadPermissions:permissionsArray]) {
//        [login logInWithReadPermissions:permissionsArray
//                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//                                  if (error) {
//                                      // Process error
//                                      failure(error);
//                                  } else if (result.isCancelled) {
//                                      // Handle cancellations
//                                      cancellation();
//                                  } else {
//                                      success(result);
//                                  }
//                                }];
//    } else if ([FBSDKLoginUtility areAllPermissionsPublishPermissions:permissionsArray]) {
//
//        [login logInWithPublishPermissions:permissionsArray
//                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//                                     if (error) {
//                                         // Process error
//                                         failure(error);
//                                     } else if (result.isCancelled) {
//                                         // Handle cancellations
//                                         cancellation();
//                                     } else {
//                                         success(result);
//                                     }
//
//                                   }];
//    } else {
//        NSAssert(NO, @"You need to use publish OR read permissions for Facebook");
//    }
}

+ (void)logout {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
}

+ (BOOL)checkFacebookPermissions:(FBSDKLoginManagerLoginResult *)session {
    NSArray *permissions = [session grantedPermissions].allObjects;
    NSArray *requiredPermissions = @[ @"publish_actions" ];

    for (NSString *perm in requiredPermissions) {
        if (![permissions containsObject:perm]) {
            return NO; // required permission not found
        }
    }
    return YES;
}

#pragma mark - Facebook API Graph Methods

+ (void)getUsersFriends:(void (^)(id result))success onFailure:(void (^)(NSError *error))failure {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
            startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
              if (!error) {
                  success(result);
              } else {
                  failure(error);
              }
            }];
    }
}

+ (void)getUsersPublicProfile:(void (^)(id result))success onFailure:(void (^)(NSError *error))failure {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
            startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
              if (!error) {
                  success(result);
              } else {
                  failure(error);
              }
            }];
    }
}

#pragma mark - Utilities

+ (BOOL)isConnected {
    if ([FBSDKAccessToken currentAccessToken]) {
        return YES;
    } else {
        return NO;
    }
}

@end
