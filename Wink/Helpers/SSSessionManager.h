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

@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *password;

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
 *  Save the user password in Keychain
 *
 *  @param password The password to store
 *  @param email    The email associated with the PNP account
 *
 *  @return True if operation succeed
 */
+ (BOOL)saveSecuredPassword:(NSString *)password withAccount:(NSString *)email;

/**
 *  Fetch the the secured password from Keychain
 *
 *  @param email The email associated with the PNP account
 *
 *  @return The password value in clear text
 */
+ (NSString *)getSecuredPasswordForAccount:(NSString *)email;

/**
 *  Delete the password in Keychain
 *
 *  @param email The email associated with the PNP account
 *
 *  @return True if operation succeed
 */
+ (BOOL)deletePasswordForAccount:(NSString *)email;

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

@end
