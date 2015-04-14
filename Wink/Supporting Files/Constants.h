//
//  Constants.h
//  Wink
//
//  Created by Justin Khan on 2015-02-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#pragma mark - URL schemes
extern NSString *const kCurrentUserStatusChanged;

extern NSString *const kSchemeFacebook;
extern NSString *const kSchemeGooglePlus;

#pragma mark - API constants

extern NSString *const kTwitterMediaUploadURL;
extern NSString *const kTwitterTweetUploadURL;
extern NSString *const kGoogleClientId;
extern NSString *const kAPIUrl;

#pragma mark - Notifications

extern NSString *const kSocialNetworkCellSwitchNotification;

#pragma mark - Soocial network

extern NSString *const kFacebookSwitchValue;
extern NSString *const kTwitterSwitchValue;
extern NSString *const kGooglePlusSwitchValue;
extern NSString *const kTumblrSwitchValue;
extern NSString *const kInstagramSwitchValue;
extern NSString *const kTwitterAccountName;
extern NSString *const kIsFacebookLoggedIn;
extern NSString *const kEmailLoggedValue;

extern NSString *const kTokenFacebookString;
extern NSString *const kTokenTwitterString;
extern NSString *const kTokenGoogleString;

#pragma mark - NSUserDefaults

extern NSString *const kIsCameraRearFacing;
extern NSString *const kIsFlashOn;
extern NSString *const kIsVideoOn;

#pragma mark - Storyboard

extern NSString *const kCameraStoryboard;

#pragma mark - Segue

extern NSString *const kCameraContainerSegue;

#define kScreenSize [UIScreen mainScreen].bounds.size
