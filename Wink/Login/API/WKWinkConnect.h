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
                                   meta:(NSDictionary *)meta
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Send the necessary data to backend in order to post stuff on social networks
 *
 *  @param data    can be the token, secret key, etc...
 *  @param success success block
 *  @param failure failure block
 */
+ (void)winkConnectSocialNetworksWithData:(NSDictionary *)data
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
