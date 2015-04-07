//
//  WKUser.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKUser.h"
#import "WKWinkConnect.h"

// User Path
#define USER_FILE_NAME              @"user"
#define USER_FILE_TYPE              @"plist"

// Notifications
NSString *const kCurrentUserInfoUpdated             = @"kCurrentUserInfoUpdated";

// Current User
static WKUser *_currentUser = nil;

@implementation WKUser

#pragma mark - Current User

+ (WKUser *)currentUser {
    if (_currentUser == nil) {
        [WKUser loadCurrentUser];
    }
    return _currentUser;
}

#pragma mark - Initializer

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        [self setupWithDictionary:dictionary];
    }
    return self;
}

#pragma mark - Setup With Dictionary

- (void)setupWithDictionary:(NSDictionary *)dictionary {
    self.userID = [dictionary objectOrNilForKey:@"id"];
    self.username = [dictionary objectOrNilForKey:@"username"];
    self.name = [dictionary objectOrNilForKey:@"name"];
    self.phone = [dictionary objectOrNilForKey:@"phone"];
    self.email = [dictionary objectOrNilForKey:@"email"];
    self.socialNetworks = [dictionary objectOrNilForKey:@"social_networks"];
    
    NSString *accessToken = [dictionary objectOrNilForKey:@"access_token"];
    if (accessToken) {
        self.accessToken = accessToken;
    }
    
    NSString *createdString = [dictionary objectOrNilForKey:@"created_datetime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.created = [formatter dateFromString:createdString];
    
    NSDictionary *managerDict = [dictionary objectOrNilForKey:@"manager"];
    if (managerDict) {
        self.manager = [[WKUser alloc] initWithDictionary:managerDict];
    }
}

#pragma mark - User Path

+ (NSString *)userPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [cachesDirectory stringByAppendingFormat:@"%@.%@", USER_FILE_NAME, USER_FILE_TYPE];
}

#pragma mark - Save & Load

+ (BOOL)saveCurrentUser {
    BOOL result = NO;
    if (_currentUser) {
        result = [NSKeyedArchiver archiveRootObject:_currentUser toFile:[WKUser userPath]];
    }
    return result;
}

+ (BOOL)loadCurrentUser {
    BOOL result = NO;
    WKUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[WKUser userPath]];
    if (user) {
        result = YES;
        _currentUser = user;
    }
    return result;
}


#pragma mark - Login & Logout

+ (void)loginUser:(WKUser *)user {
    if (user) {
        _currentUser = user;
        [WKUser saveCurrentUser];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentUserStatusChanged object:_currentUser];
    }
}

+ (void)logoutCurrentUser {
    if (_currentUser) {
        _currentUser = nil;
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[WKUser userPath] error:&error];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentUserStatusChanged object:_currentUser];
    }
}

#pragma mark - Coding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.created forKey:@"created"];
    [aCoder encodeObject:self.socialNetworks forKey:@"socialNetworks"];
    [aCoder encodeObject:self.manager forKey:@"manager"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.created = [aDecoder decodeObjectForKey:@"created"];
        self.socialNetworks = [aDecoder decodeObjectForKey:@"socialNetworks"];
        self.manager = [aDecoder decodeObjectForKey:@"manager"];
    }
    return self;
}

@end
