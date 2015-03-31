//
//  NSDictionary+WKAdditions.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "NSDictionary+WKAdditions.h"

@implementation NSDictionary (WKAdditions)

- (id)objectOrNilForKey:(id)aKey {
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
}

@end
