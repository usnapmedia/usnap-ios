//
//  SSOFeedConnect.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-21.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface SSOFeedConnect : NSObject

//@FIXME We need to adjust this to get the photos per campaign

/**
 *  Get the latest live feed photos
 *
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getliveFeedPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Get the top photos
 *
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getTopPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
