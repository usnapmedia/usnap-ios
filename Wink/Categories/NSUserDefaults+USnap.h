//
//  NSUserDefaults+USnap.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (USnap)

+ (BOOL)isFirstLogin;

+ (BOOL)isUserLoggedIn;

+ (NSString *)loggedInUserEmail;

@end
