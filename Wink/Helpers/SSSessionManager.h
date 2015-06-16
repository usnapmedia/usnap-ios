//
//  SSSessionManager.h
//  pnp
//
//  Created by Gabriel Cartier on 2014-11-25.
//  Copyright (c) 2014 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSSessionManager : NSObject

/**
 *  Get the singleton instance
 *
 *  @return the singleton instance
 */
+ (SSSessionManager *)sharedInstance;

#pragma mark - Properties of the session

@property(strong, nonatomic, readonly) NSString *username;
@property(strong, nonatomic, readonly) NSString *password;
@property(strong, nonatomic, readonly) NSString *campaignID;

@property(assign, nonatomic, readonly) UIDeviceOrientation lastPhotoOrientation;
@property(strong, nonatomic, readonly) NSURL *lastVideoURL;

#pragma mark - Session methods

/**
 *  Initialize data from the keychain and userdefault. This is called once in app delegate
 */
- (void)initializeData;

/**
 *  Check if the user is currently logged in
 *
 *  @return YES if the user logged in, NO otherwise
 */
- (BOOL)isUserLoggedIn;

/**
 *  Logout the current user. Will erase the data from the keychain
 */
- (void)logoutCurrentUser;

/**
 *  Login the user and set the values
 *
 *  @param username the username
 *  @param password the password
 */
- (void)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password;

/**
 *  Username of the current user
 *
 *  @return the username
 */
- (NSString *)currentUsername;

/**
 *  Set the current campaign ID
 *
 *  @param campaignID campaign ID
 */
- (void)setCampaignID:(NSString *)campaignID;

- (void)setLastPhotoOrientation:(UIDeviceOrientation)lastPhotoOrientation;

- (void)setLastVideoURL:(NSURL *)lastVideoURL;

@end
