//
//  WKWinkConnect.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKWinkConnect.h"
#import "Constants.h"
#import "SSOHTTPRequestOperationManager.h"
#import "SSSessionManager.h"

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
    NSString *url = [NSString stringWithFormat:@"login"];
    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
    [manager POST:url parameters:@{ @"email" : email, @"password" : password } success:success failure:failure];
}

+ (void)winkConnectRegisterWithUsername:(NSString *)email
                               password:(NSString *)password
                                   meta:(NSDictionary *)meta
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"register"];

    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];

    [manager POST:url parameters:@{ @"email" : email, @"password" : password, @"meta" : meta } success:success failure:failure];
}

+ (void)winkConnectSocialNetworksWithData:(NSDictionary *)data
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"connect"];
    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];

    [manager POST:url parameters:data success:success failure:failure];
}

+ (void)winkConnectPostImageToBackend:(UIImage *)imageToPost
                             withText:(NSString *)text
                              andMeta:(NSDictionary *)meta
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"share"];

    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 0.5);

    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    // We need to reset the contentTypes here as we are setting a new responseSerializer
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = responseSerializer;

    // TODO: Temporary fix because problem with backend
    int randomNumber = arc4random_uniform(1000);
    NSString *temporaryFileName = [NSString stringWithFormat:@"image%i.jpg", randomNumber];

    [manager POST:url parameters:@{
        @"text" : text,
        @"meta" : meta
    } constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      [formData appendPartWithFileData:imageData name:@"image_data" fileName:temporaryFileName mimeType:@"image/jpg"];
    } success:success failure:failure];
}

@end
