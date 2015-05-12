//
//	SSOUser.h
//
//	Create by Marcelo de Souza on 11/5/2015
//	Copyright © 2015. All rights reserved.
//
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface SSOUser : NSObject

@property(nonatomic, strong) NSString *dob;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSObject *profilePic;
@property(nonatomic, strong) NSString *username;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
@end