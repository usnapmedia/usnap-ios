//
//  WKWinkConnect.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "AFHTTPRequestOperationManager.h"

// Notification
extern NSString *const kWinkConnectAuthorizationDenied;

@interface WKWinkConnect : NSObject

// Login
+ (void)winkConnectLoginWithUsername:(NSString *)email
                            password:(NSString *)password
                                meta:(NSString *)meta
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)winkConnectRegisterWithUsername:(NSString *)email
                               password:(NSString *)password
                                   meta:(NSString *)meta
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
