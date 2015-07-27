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
extern NSString *const kTwitterConsumerSecret;
extern NSString *const kTwitterConsumerKey;
extern NSString *const kTwitterMediaUploadURL;
extern NSString *const kTwitterTweetUploadURL;
extern NSString *const kGoogleClientId;
extern NSString *const kSegmentIoKey;
extern NSString *const kAPIUrl;
extern NSString *const kAPIKey;
extern NSString *const kAPIValue;

#pragma mark - Notifications

extern NSString *const kSocialNetworkCellSwitchNotification;

#pragma mark - Soocial network
// Settings switches
extern NSString *const kFacebookSwitchValue;
extern NSString *const kTwitterSwitchValue;
extern NSString *const kGooglePlusSwitchValue;
extern NSString *const kTumblrSwitchValue;
extern NSString *const kInstagramSwitchValue;

extern NSString *const kTwitterAccountName;
extern NSString *const kIsFacebookLoggedIn;
extern NSString *const kEmailLoggedValue;
// Tokens
extern NSString *const kTokenFacebookString;
extern NSString *const kTokenTwitterString;
extern NSString *const kTokenGoogleString;

extern NSString *const kFacebookSelected;
extern NSString *const kTwitterSelected;
extern NSString *const kGoogleSelected;

#pragma mark - NSUserDefaults

// Camera
extern NSString *const kDevicePosition;
extern NSString *const kFlashState;
extern NSString *const kTorchState;
extern NSString *const kIsVideoOn;

// Login
extern NSString *const kIsFirstLogin;
extern NSString *const kIsFirstLoginDate;
extern NSString *const kIsUserLoggedIn;
extern NSString *const kEmailLoggedString;
extern NSString *const kCurrentCampaignID;

// Keychain
extern NSString *const kUSnapKeychainServiceKey;

#pragma mark - Storyboard

extern NSString *const kCameraStoryboard;

#pragma mark - Segue

extern NSString *const kCameraContainerSegue;

#pragma mark - Adjustement tool

#define kSliderMinimumValue 0.0f
#define kSliderMaximumValue 1.0f
#define kSliderDefaultValue 0.5f
#define kTabBarHeight 40

#define kScreenSize [UIScreen mainScreen].bounds.size

#pragma mark - Photos

extern NSInteger const kTopViewHeightConstraint;
extern NSInteger const kConstraintOffset;
extern NSInteger const kButtonWidthConstraint;
extern NSInteger const kNumberOfTopPhotos;

#pragma mark - Video

extern NSInteger const kDefaultAnimationDuration;

#pragma mark - Cells
extern NSString *const kTopPhotosNib;
extern NSString *const kTopPhotosReusableId;
extern NSString *const kImageCollectionViewCell;
extern NSString *const kImageCollectionViewCellNib;
extern NSString *const kPhotosCollectionViewCell;
extern NSString *const kPhotosNibNameCollectionViewCell;

#pragma mark - Notifications

extern NSString *const kReturnToFanPageVC;
extern NSString *const kDeviceOrientationNotification;