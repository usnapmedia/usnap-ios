//
//  SSOOrientationHelper.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOOrientationHelper.h"


@implementation SSOOrientationHelper

+ (SSOOrientationHelper *)sharedInstance {
    static SSOOrientationHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
