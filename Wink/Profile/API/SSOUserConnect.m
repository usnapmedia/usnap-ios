//
//  SSOUserConnect.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-11.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOUserConnect.h"
#import "Constants.h"
#import "SSOHTTPRequestOperationManager.h"
#import "SSSessionManager.h"

@implementation SSOUserConnect

+ (void)getUserInformationWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"users/me"];
    SSOHTTPRequestOperationManager *manager = [[SSOHTTPRequestOperationManager alloc] init];
    [manager GET:url parameters:nil success:success failure:failure];
}

@end
