//
//  NSUserDefaults+USnap.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "NSUserDefaults+USnap.h"
#import "SSSessionManager.h"

@implementation NSUserDefaults (USnap)

+ (BOOL)isFirstLogin {
    // Check if there is a first launch date
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kIsFirstLoginDate]) {
        // set firstLaunch flag to initial date
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kIsFirstLoginDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    } else { // Else, not the first launch
        return NO;
    }
}

+ (BOOL)isUserLoggedIn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kIsUserLoggedIn] boolValue] ? YES : NO;
}

+ (NSString *)loggedInUserEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEmailLoggedString];
}

@end
