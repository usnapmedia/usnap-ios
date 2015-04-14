//
//  Constants.m
//  Wink
//
//  Created by Justin Khan on 2015-02-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

NSString *const kCurrentUserStatusChanged = @"kCurrentUserStatusChanged";

#pragma mark - URL schemes

NSString *const kSchemeFacebook = @"fb284759385065022";
NSString *const kSchemeGooglePlus = @"com.samsao.winktalent";

#pragma mark - API constants

NSString *const kTwitterMediaUploadURL = @"https://upload.twitter.com/1.1/media/upload.json";
NSString *const kTwitterTweetUploadURL = @"https://api.twitter.com/1.1/statuses/update.json";
NSString *const kGoogleClientId = @"705787939641-q7u2cb9tbrd04ku4jc99h4bd5c1cs7bk.apps.googleusercontent.com";
NSString *const kAPIUrl = @"http://d.tanios.ca/usnap/api/v1";

#pragma mark - Notifications

NSString *const kSocialNetworkCellSwitchNotification = @"SOCIAL_NETWORK_CELL_SWITCH_NOTIFICATION";

#pragma mark - Soocial network
//@TODO Refactor
NSString *const kFacebookSwitchValue = @"FacebookSwitchValue";
NSString *const kTwitterSwitchValue = @"TwitterSwitchValue";
NSString *const kGooglePlusSwitchValue = @"Google+SwitchValue";
NSString *const kTumblrSwitchValue = @"TumblSwitchValue";
NSString *const kInstagramSwitchValue = @"InstagramSwitchValue";
NSString *const kIsFacebookLoggedIn = @"kIsFacebookLoggedIn";
NSString *const kTwitterAccountName = @"kTwitterAccountName";
NSString *const kEmailLoggedValue = @"kEmailLoggedValue";

NSString *const kTokenFacebookString = @"kTokenFacebookString";
NSString *const kTokenTwitterString = @"kTokenTwitterString";
NSString *const kTokenGoogleString = @"kTokenGoogleString";

#pragma mark - NSUserDefaults

NSString *const kIsCameraRearFacing = @"kIsCameraRearFacing";
NSString *const kIsFlashOn = @"kIsFlashOn";
NSString *const kIsVideoOn = @"kIsVideoOn";

NSString *const kIsFirstLogin = @"kIsFirstLogin";
NSString *const kIsFirstLoginDate = @"kIsFirstLoginDate";
NSString *const kUSnapKeychainServiceKey = @"kUSnapKeychainServiceKey";

NSString *const kIsUserLoggedIn = @"kIsUserLoggedIn";
NSString *const kEmailLoggedString = @"kEmailLoggedString";

#pragma mark - Storyboard

NSString *const kCameraStoryboard = @"Camera";

#pragma mark - Segue

NSString *const kCameraContainerSegue = @"CAMERA_CONTAINER_SEGUE";
