//
//  SSOHTTPRequestOperationManager.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOHTTPRequestOperationManager.h"
#import "SSSessionManager.h"

@implementation SSOHTTPRequestOperationManager

/**
 *  Overide init method
 *  Directly pass the backend base URL and set content types
 *
 *  @return self
 */
- (instancetype)init {

    NSURL *baseURL = [NSURL URLWithString:kAPIUrl];
    if (self = [super initWithBaseURL:baseURL]) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

        // Check if the user is already logged in
        if ([[SSSessionManager sharedInstance] isUserLoggedIn]) {
            // Set header auth
            [self.requestSerializer setAuthorizationHeaderFieldWithUsername:[SSSessionManager sharedInstance].username
                                                                   password:[SSSessionManager sharedInstance].password];
        }
    }
    return self;
}

@end
