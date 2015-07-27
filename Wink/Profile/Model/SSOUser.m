//
//	SSOUser.m
//
//	Create by Marcelo de Souza on 11/5/2015
//	Copyright © 2015. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import "SSOUser.h"

@interface SSOUser ()
@end
@implementation SSOUser

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (![dictionary[@"dob"] isKindOfClass:[NSNull class]]) {
        self.dob = dictionary[@"dob"];
    }
    if (![dictionary[@"email"] isKindOfClass:[NSNull class]]) {
        self.email = dictionary[@"email"];
    }
    if (![dictionary[@"first_name"] isKindOfClass:[NSNull class]]) {
        self.firstName = dictionary[@"first_name"];
    }
    if (![dictionary[@"last_name"] isKindOfClass:[NSNull class]]) {
        self.lastName = dictionary[@"last_name"];
    }
    if (![dictionary[@"profile_pic"] isKindOfClass:[NSNull class]]) {
        self.profilePic = dictionary[@"profile_pic"];
    }
    if (![dictionary[@"username"] isKindOfClass:[NSNull class]]) {
        self.username = dictionary[@"username"];
    }
    if (![dictionary[@"contribution"] isKindOfClass:[NSNull class]]) {
        self.contribution = dictionary[@"contribution"];
    }
    if (![dictionary[@"score"] isKindOfClass:[NSNull class]]) {
        self.score = dictionary[@"score"];
    }
    return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the
 * corresponding property
 */
- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.dob != nil) {
        dictionary[@"dob"] = self.dob;
    }
    if (self.email != nil) {
        dictionary[@"email"] = self.email;
    }
    if (self.firstName != nil) {
        dictionary[@"first_name"] = self.firstName;
    }
    if (self.lastName != nil) {
        dictionary[@"last_name"] = self.lastName;
    }
    if (self.profilePic != nil) {
        dictionary[@"profile_pic"] = self.profilePic;
    }
    if (self.username != nil) {
        dictionary[@"username"] = self.username;
    }
    if (self.username != nil) {
        dictionary[@"contribution"] = self.contribution;
    }
    if (self.username != nil) {
        dictionary[@"score"] = self.score;
    }
    return dictionary;
}
@end