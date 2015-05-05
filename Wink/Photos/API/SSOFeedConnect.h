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

/**
 *  Get the latest live feed photos
 *
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getRecentPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  Get the top photos
 *
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getTopPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Get the user's feed
 *
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getMyFeedWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Get the latest live feed photos
 *
 *  @param campaignID   the id of the campaign
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getRecentPhotosForCampaignId:(NSString *)campaignID
                         withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  Get the top photos
 *
 *  @param campaignID   the id of the campaign
 *  @param success success block
 *  @param failure failure block
 */
+ (void)getTopPhotosForCampaignId:(NSString *)campaignID
                      withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
