//
//  SSFacebookHelper.h
//  reccard
//
//  Created by Gabriel Cartier on 12/17/2013.
//  Copyright (c) 2013 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSDKLoginManager.h"
#import "FBSDKLoginManagerLoginResult.h"
#import "FBSDKAccessToken.h"
#import "FBSDKGraphRequest.h"
#import "FBSDKGraphRequestConnection.h"

@interface SSFacebookHelper : NSObject

#pragma mark - Login Methods

/**
 *  Log user in with a completion handle
 *
 *  @param permissionsArray List of permissions that the app will require
 *  @param success Method to call on success
 *  @param failure Method to call on failure
 *  @param cancellation to call on cancellation
 */
+ (void)loginWithPermissions:(NSArray *)permissionsArray
                   onSuccess:(void (^)(FBSDKLoginManagerLoginResult *result))success
                   onFailure:(void (^)(NSError *error))failure
              onCancellation:(void (^)(void))cancellation;

/**
 *  Log user out
 */
+ (void)logout;

#pragma mark - Facebook API Methods

/**
 *  Load users friends that are also users of the app you're working and also logged in using Facebook
 *
 *  @param success Method to call on success
 *  @param failure Method to call on failure
 */
+ (void)getUsersFriends:(void (^)(id result))success onFailure:(void (^)(NSError *error))failure;

/**
 *  Get user's public profile which includes the user's first and last name, gender, location, etc.
 *
 *  @param success Method to call on success
 *  @param failure Method to call on failure
 */
+ (void)getUsersPublicProfile:(void (^)(id result))success onFailure:(void (^)(NSError *error))failure;

#pragma mark - Utilities

/**
 * isConnected
 * Check if the user is currently connected to Facebook
 *
 * @return: BOOL: YES if connected, else NO
 */
+ (BOOL)isConnected;

@end
