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

//- (void)setPassword:(NSString *)password {
//    if (_username) {
//        SSKeychain setPassword:<#(NSString *)#> forService:<#(NSString *)#> account:<#(NSString *)#>
//        [SSUserManager saveSecuredPassword:password withAccount:_username];
//        _password = password;
//    } else {
//        CLS_LOG(@"Trying to save a password on a non-logged in user");
//    }
//}

+ (BOOL)saveSecuredPassword:(NSString *)password withAccount:(NSString *)email {
    NSLog(@"Saving password in keychain..");
    [[SSSessionManager sharedInstance] loginUserWithUsername:email andPassword:password];
    return [SSKeychain setPassword:password forService:kUSnapKeychainServiceKey account:email];
}

+ (NSString *)getSecuredPasswordForAccount:(NSString *)email {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleAfterFirstUnlock];
    return [SSKeychain passwordForService:kUSnapKeychainServiceKey account:email];
}

+ (BOOL)deletePasswordForAccount:(NSString *)email {
    NSLog(@"Deleting password from keychain..");
    return [SSKeychain deletePasswordForService:kUSnapKeychainServiceKey account:email];
}

#pragma mark - Session methods

- (void)initializeData {
    // Initialize the data from the user default and  keychain
    if ([NSUserDefaults isUserLoggedIn]) {
        _isUserLoggedIn = YES;
        _username = [NSUserDefaults loggedInUserEmail];
        _password = [SSSessionManager getSecuredPasswordForAccount:self.username];
    } else {
        _isUserLoggedIn = NO;
    }
}

- (BOOL)isUserLoggedIn {
    return _isUserLoggedIn;
}

- (void)logoutCurrentUser {
    // delete password in Keychain
    [SSSessionManager deletePasswordForAccount:_username];
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
    //  [SSSessionManager saveSecuredPassword:password withAccount:username];
    // set isUserLogged flag to YES (hack to get the authentification working)
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLoggedIn];

    // store email in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kEmailLoggedString];

    // Synchronize the UserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)currentUsername {
    return _username;
}

@end
