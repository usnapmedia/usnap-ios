//
//  Constants.h
//  Wink
//
//  Created by Justin Khan on 2015-02-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#pragma mark - API constants

extern NSString *const kTwitterMediaUploadURL;
extern NSString *const kTwitterTweetUploadURL;

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

#pragma mark - NSUserDefaults

extern NSString *const kIsCameraRearFacing;
extern NSString *const kIsFlashOn;
extern NSString *const kIsVideoOn;

#pragma mark - Storyboard

extern NSString *const kCameraStoryboard;

#pragma mark - Segue

extern NSString *const kCameraContainerSegue;

#define kScreenSize [UIScreen mainScreen].bounds.size