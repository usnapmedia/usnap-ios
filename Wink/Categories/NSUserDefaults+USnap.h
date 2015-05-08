//
//  NSUserDefaults+USnap.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (USnap)

#pragma mark - Login

/**
 *  Check if it is the first login
 *
 *  @return YES if it is, NO if it is not
 */
+ (BOOL)isFirstLogin;

/**
 *  Check if user is logged in
 *
 *  @return YES if the user is logged in
 */
+ (BOOL)isUserLoggedIn;

/**
 *  Get the username of the currently logged in user
 *
 *  @return the username
 */
+ (NSString *)loggedInUsername;

#pragma mark - Campaign

/**
 *  Set the current campaign ID
 *
 *  @param campaignID the campaign ID
 */
+(void)setCurrentCampaign:(NSString *)campaignID;


/**
 *  Get the current campaign ID
 *
 *  @return the campaign ID
 */
+(NSString *)currentCampaignID;

@end

