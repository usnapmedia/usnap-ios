//
//  WKWinkConnect.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

// Notification
extern NSString *const kWinkConnectAuthorizationDenied;

@interface WKWinkConnect : NSObject

// Login
+ (AFHTTPRequestOperation *)winkConnectLoginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure;

// Get User Info
+ (AFHTTPRequestOperation *)winkConnectGetUserInfo:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure;

// Post Image
+ (AFHTTPRequestOperation *)winkConnectPostImage:(UIImage *)image modifiedImage:(UIImage *)modifiedImage overlayImage:(UIImage *)overlayImage text:(NSString *)text accessToken:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure;

// Post Video
+ (AFHTTPRequestOperation *)winkConnectPostVideo:(NSURL *)videoURL overlayImage:(UIImage *)overlayImage text:(NSString *)text accessToken:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure;

@end
