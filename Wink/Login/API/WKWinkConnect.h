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

@interface WKWinkConnect : NSObject

/**
 *  Login the user to the backend
 *
 *  @param email    the email
 *  @param password the password
 *  @param meta     the metadata @FIXME THIS SHOULD GO
 *  @param success  success block
 *  @param failure  failure block
 */
+ (void)winkConnectLoginWithUsername:(NSString *)email
                            password:(NSString *)password
                                meta:(NSString *)meta
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Register the user to the backend
 *
 *  @param email    the email
 *  @param password the password
 *  @param username the username
 *  @param firstName the firstName
 *  @param lastName the lastName
 *  @param birthday the birthday date
 *  @param success  success block
 *  @param failure  failure block
 */
+ (void)winkConnectRegisterWithEmail:(NSString *)email
                            password:(NSString *)password
                            username:(NSString *)username
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                            birthday:(NSString *)birthday
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

/**
 *  Post an image to the backend with multipart form data
 *
 *  @param imageToPost the image to post
 *  @param text        the text that goes with the image
 *  @param meta        description
 *  @param success     success block
 *  @param failure     failure block
 */
+ (void)winkConnectPostImageToBackend:(UIImage *)imageToPost
                             withText:(NSString *)text
                              andMeta:(NSDictionary *)meta
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Post a video to the backend with multipart form data
 *
 *  @param URLOfVideoToPost The URL of the video to post
 *  @param text        the text that goes with the video
 *  @param success     success block
 *  @param failure     failure block
 */
+ (void)winkConnectPostVideoToBackend:(NSURL *)URLOfVideoToPost
                             withText:(NSString *)text
                         overlayImage:(UIImage *)overlayImage
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Get the current campaigns from backend
 *
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getCampaignsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
