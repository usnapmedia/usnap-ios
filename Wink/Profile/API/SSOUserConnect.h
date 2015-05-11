//
//  SSOUserConnect.h
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-11.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "AFHTTPRequestOperationManager.h"

@interface SSOUserConnect : NSObject

/**
 *  Get the user information
 *
 *  @param success success block
 *  @param failure failure block
 */

+ (void)getUserInformationWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
