//
//  WKUser.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
extern NSString *const kCurrentUserInfoUpdated;

@interface WKUser : NSObject <NSCoding> {
    
}

// Info
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray *socialNetworks;
@property (nonatomic, strong) WKUser *manager;

// Current User
+ (WKUser *)currentUser;

// Initializer
- (id)initWithDictionary:(NSDictionary *)dictionary;

// Save & Load
+ (BOOL)saveCurrentUser;
+ (BOOL)loadCurrentUser;


// Login & Logout
+ (void)loginUser:(WKUser *)user;
+ (void)logoutCurrentUser;

@end
