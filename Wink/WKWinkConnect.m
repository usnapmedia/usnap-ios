//
//  WKWinkConnect.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKWinkConnect.h"

// API Host
#define WINK_API_HOST               @"api.wink.la:444"

// Access Tokens
// DEV
//#define WINK_ACCESS_TOKEN           @"184d81c0-4c4a-93e1-86d5-e0f7b630a235"
// PROD
#define WINK_ACCESS_TOKEN           @"33c3c763-aebc-599d-4e66-6553e24a2f76"

// Request Types
#define GET                         @"GET"
#define POST                        @"POST"
#define PUT                         @"PUT"
#define DELETE                      @"DELETE"

// Notification
NSString *const kWinkConnectAuthorizationDenied      = @"kWinkConnectAuthorizationDenied";

@implementation WKWinkConnect

#pragma mark - Login

+ (AFHTTPRequestOperation *)winkConnectLoginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure {
    NSString *url = [NSString stringWithFormat:@"https://%@/v2/users", WINK_API_HOST];
    AFHTTPRequestOperation *operation = [WKWinkConnect requestWithUrl:url type:POST path:nil params:[NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil] data:nil accessToken:WINK_ACCESS_TOKEN success:success failure:failure];
    [operation start];
    return operation;
}

#pragma mark - Get User Info

+ (AFHTTPRequestOperation *)winkConnectGetUserInfo:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure {
    NSString *url = [NSString stringWithFormat:@"https://%@/v2/users", WINK_API_HOST];
    AFHTTPRequestOperation *operation = [WKWinkConnect requestWithUrl:url type:GET path:nil params:nil data:nil accessToken:accessToken success:success failure:failure];
    [operation start];
    return operation;
}

#pragma mark - Post

+ (AFHTTPRequestOperation *)winkConnectPostImage:(UIImage *)image modifiedImage:(UIImage *)modifiedImage overlayImage:(UIImage *)overlayImage text:(NSString *)text accessToken:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure {
    NSString *url = [NSString stringWithFormat:@"https://%@/posts", WINK_API_HOST];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSData *modifiedImageData = UIImageJPEGRepresentation(modifiedImage, 1);
    NSData *overlayImageData = UIImagePNGRepresentation(overlayImage);
    if (imageData) {
        [data setObject:imageData forKey:@"image-image.jpg-image/jpeg"];
    }
    if (modifiedImageData) {
        [data setObject:modifiedImageData forKey:@"modified_image-modified_image.jpg-image/jpeg"];
    }
    if (overlayImageData) {
        [data setObject:overlayImageData forKey:@"overlay_image-overlay_image.png-image/png"];
    }
    AFHTTPRequestOperation *operation = [WKWinkConnect requestWithUrl:url type:POST path:nil params:[NSDictionary dictionaryWithObjectsAndKeys:text, @"text", nil] data:data accessToken:accessToken success:success failure:failure];
    [operation start];
    return operation;
}

#pragma mark - Post Video

+ (AFHTTPRequestOperation *)winkConnectPostVideo:(NSURL *)videoURL overlayImage:(UIImage *)overlayImage text:(NSString *)text accessToken:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure {
    NSString *url = [NSString stringWithFormat:@"https://%@/posts", WINK_API_HOST];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (videoURL) {
        [data setObject:videoURL forKey:@"video-video.mov-video/quicktime"];
    }
    NSData *overlayImageData = UIImagePNGRepresentation(overlayImage);
    if (overlayImage) {
        [data setObject:overlayImageData forKey:@"overlay_image-overlay_image.png-image/png"];
    }
    AFHTTPRequestOperation *operation = [WKWinkConnect requestWithUrl:url type:POST path:nil params:[NSDictionary dictionaryWithObjectsAndKeys:text, @"text", nil] data:data accessToken:accessToken success:success failure:failure];
    [operation start];
    return operation;
}

#pragma mark - Request Method

+ (AFHTTPRequestOperation *)requestWithUrl:(NSString *)urlString type:(NSString *)type path:(NSString *)path params:(NSDictionary *)params data:(NSDictionary *)data accessToken:(NSString *)accessToken success:(void (^)(id response))success failure:(void (^)(NSError *error, id response))failure {
    
    // Encode and create the url
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Create the request with authentication
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = nil;
    if (data == nil) {
        request = [manager.requestSerializer requestWithMethod:type URLString:urlString parameters:params error:nil];
    }
    else {
        NSError *error = nil;
        request = [manager.requestSerializer multipartFormRequestWithMethod:type URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (NSString *key in data.allKeys) {
                NSArray *components = [key componentsSeparatedByString:@"-"];
                if (components.count == 3) {
                    NSError *error2 = nil;
                    NSString *name = components[0];
                    NSString *fileName = components[1];
                    NSString *mimeType = components[2];
                    
                    id dataObject = [data objectForKey:key];
                    if ([dataObject isKindOfClass:[NSData class]]) {
                        [formData appendPartWithFileData:(NSData *)dataObject name:name fileName:fileName mimeType:mimeType];
                    }
                    else if ([dataObject isKindOfClass:[NSURL class]]) {
                        [formData appendPartWithFileURL:(NSURL *)dataObject name:name fileName:fileName mimeType:mimeType error:&error2];
                    }
                }
            }
            
        } error:&error];
    }
    [request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:[self deviceUuid] forHTTPHeaderField:@"X_WINK_DEVICE_ID"];
    
    // Create the operation that expects a JSON as a response
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.responseObject);
        }
        
        // If receving a 403 error code then log the user out
        if (operation.response.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kWinkConnectAuthorizationDenied object:nil];
        }
    }];

    return operation;
}

#pragma mark - Device Uuid

+ (NSString *)deviceUuid {
    NSString *deviceUuid = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id uuid = [defaults objectForKey:@"deviceUuid"];
    if (uuid)
        deviceUuid = (NSString *)uuid;
    else {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef cfUuid = CFUUIDCreateString(NULL, uuidRef);
        deviceUuid = (__bridge NSString *)cfUuid;
        [defaults setObject:deviceUuid forKey:@"deviceUuid"];
        CFRelease(cfUuid);
        CFRelease(uuidRef);
    }
    return deviceUuid;
}

@end
