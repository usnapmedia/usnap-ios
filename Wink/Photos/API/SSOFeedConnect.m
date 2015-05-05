//
//  SSOFeedConnect.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-21.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFeedConnect.h"
#import "SSOHTTPRequestOperationManager.h"

@implementation SSOFeedConnect

+ (void)getRecentPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"feed/live"];
    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:nil success:success failure:failure];
}

+ (void)getTopPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"feed/top"];
    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:nil success:success failure:failure];
}

+ (void)getMyFeedWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"feed/live/me"];
    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:nil success:success failure:failure];
}

+ (void)getRecentPhotosForCampaignId:(NSString *)campaignID
                         withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    // Check if there is a campaign ID, else simple call the default route
    if (!campaignID) {
        [SSOFeedConnect getRecentPhotosWithSuccess:success failure:failure];
    } else {
        NSString *url = [NSString stringWithFormat:@"feed/live/%@", campaignID];
        SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
        [manager GET:url parameters:nil success:success failure:failure];
    }
}

+ (void)getTopPhotosForCampaignId:(NSString *)campaignID
                      withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    // Check if there is a campaign ID, else simple call the default route
    if (!campaignID) {
        [SSOFeedConnect getTopPhotosWithSuccess:success failure:failure];
    } else {
        NSString *url = [NSString stringWithFormat:@"feed/top/%@", campaignID];
        SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
        [manager GET:url parameters:nil success:success failure:failure];
    }
}

@end
