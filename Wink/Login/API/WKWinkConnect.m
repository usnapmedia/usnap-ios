//
//  WKWinkConnect.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKWinkConnect.h"
#import "Constants.h"

// Request Types
#define GET @"GET"
//#define POST @"POST"
#define PUT @"PUT"
#define DELETE @"DELETE"

// Notification
NSString *const kWinkConnectAuthorizationDenied = @"kWinkConnectAuthorizationDenied";

@implementation WKWinkConnect

#pragma mark - Login

+ (void)winkConnectLoginWithUsername:(NSString *)email
                            password:(NSString *)password
                                meta:(NSString *)meta
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@/login", kAPIUrl];

    // AFHTTPRequestOperation *operation = [AFHTTPRequestOperation alloc]init

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:@{ @"email" : email, @"password" : password } success:success failure:failure];
}

+ (void)winkConnectRegisterWithUsername:(NSString *)email
                               password:(NSString *)password
                                   meta:(NSDictionary *)meta
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@/register", kAPIUrl];

    // AFHTTPRequestOperation *operation = [AFHTTPRequestOperation alloc]init

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError *error;
  //  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:meta options:NSJSONWritingPrettyPrinted error:&error];
    
   // manager.requestSerializer enco

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:@{ @"email" : email, @"password" : password, @"meta" : meta } success:success failure:failure];
}

+ (void)winkConnectSocialNetworksWithData:(NSDictionary *)data
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"%@/connect", kAPIUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:data success:success failure:failure];
}

@end
