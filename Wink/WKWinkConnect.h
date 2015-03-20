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

+ (AFHTTPRequestOperation *)winkConnectLoginWithUsername:(NSString *)username
                                                password:(NSString *)password
                                                 success:(void (^)(id response))success
                                                 failure:(void (^)(NSError *error, id response))failure;

// Get User Info
+ (AFHTTPRequestOperation *)winkConnectGetUserInfo:(NSString *)accessToken
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *error, id response))failure;

// Post Image
+ (AFHTTPRequestOperation *)winkConnectPostImage:(UIImage *)image
                                   modifiedImage:(UIImage *)modifiedImage
                                    overlayImage:(UIImage *)overlayImage
                                            text:(NSString *)text
                                     accessToken:(NSString *)accessToken
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *error, id response))failure;

// Post Video
+ (AFHTTPRequestOperation *)winkConnectPostVideo:(NSURL *)videoURL
                                    overlayImage:(UIImage *)overlayImage
                                            text:(NSString *)text
                                     accessToken:(NSString *)accessToken
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *error, id response))failure;

@end
