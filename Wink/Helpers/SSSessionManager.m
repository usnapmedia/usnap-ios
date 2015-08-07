//
//  SSSessionManager.m
//  pnp
//
//  Created by Gabriel Cartier on 2014-11-25.
//  Copyright (c) 2014 Samsao. All rights reserved.
//

#import "SSSessionManager.h"
//#import "SSUserManager.h"
#import "NSUserDefaults+USnap.h"
#import <SSKeychain.h>

@interface SSSessionManager ()

@property(nonatomic) BOOL isUserLoggedIn;
@property(strong, nonatomic, readwrite) NSString *username;
@property(strong, nonatomic, readwrite) NSString *password;
@property(strong, nonatomic, readwrite) SSOCampaign * campaign;

@property(assign, nonatomic, readwrite) UIDeviceOrientation lastPhotoOrientation;

@end

@implementation SSSessionManager

+ (SSSessionManager *)sharedInstance {
    static SSSessionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
      [sharedInstance initializeData];
    });
    return sharedInstance;
}

#pragma mark - Setters

/**
 *  Save the user password in Keychain
 *
 *  @param password The password to store
 *  @param email    The email associated with the PNP account
 *
 *  @return True if operation succeed
 */
- (BOOL)saveSecuredPassword:(NSString *)password withAccount:(NSString *)email {
    NSLog(@"Saving password in keychain..");
    return [SSKeychain setPassword:password forService:kUSnapKeychainServiceKey account:email];
}

/**
 *  Fetch the the secured password from Keychain
 *
 *  @param email The email associated with the PNP account
 *
 *  @return The password value in clear text
 */
- (NSString *)getSecuredPasswordForAccount:(NSString *)email {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleAfterFirstUnlock];
    return [SSKeychain passwordForService:kUSnapKeychainServiceKey account:email];
}

/**
 *  Delete the password in Keychain
 *
 *  @param email The email associated with the PNP account
 *
 *  @return True if operation succeed
 */
- (BOOL)deletePasswordForAccount:(NSString *)email {
    NSLog(@"Deleting password from keychain..");
    return [SSKeychain deletePasswordForService:kUSnapKeychainServiceKey account:email];
}

- (void)setCampaign:(SSOCampaign *)campaign {
    _campaign = campaign;
    [NSUserDefaults setCurrentCampaign:campaign];
}

#pragma mark - Getters

- (BOOL)isUserLoggedIn {
    return _isUserLoggedIn;
}

- (NSString *)currentUsername {
    return _username;
}

#pragma mark - Session methods

- (void)initializeData {
    // Set the current campaign ID
    _campaign = [NSUserDefaults currentCampaign];

    // Initialize the data from the user default and  keychain
    if ([NSUserDefaults isUserLoggedIn]) {
        _isUserLoggedIn = YES;
        _username = [NSUserDefaults loggedInUsername];
        _password = [self getSecuredPasswordForAccount:self.username];
    } else {
        _isUserLoggedIn = NO;
    }
}

- (void)logoutCurrentUser {
    // delete password in Keychain
    [self deletePasswordForAccount:_username];
    // delete email in NSUserDefaults

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kEmailLoggedString];

    // put user is logged to NO
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsUserLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.isUserLoggedIn = NO;
    _username = nil;
    _password = nil;
}

- (void)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password {
    _username = username;
    _password = password;
    _isUserLoggedIn = YES;

    // Save the password in the keychain
    [self saveSecuredPassword:password withAccount:username];
    // set isUserLogged flag to YES (hack to get the authentification working)
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLoggedIn];

    // store email in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kEmailLoggedString];

    // Synchronize the UserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastPhotoOrientation:(UIDeviceOrientation)lastPhotoOrientation {
    _lastPhotoOrientation = lastPhotoOrientation;
}

- (void)setLastVideoURL:(NSURL *)lastVideoURL {
    _lastVideoURL = lastVideoURL;
}

@end
