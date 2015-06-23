//
//  Constants.m
//  Wink
//
//  Created by Justin Khan on 2015-02-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#pragma mark - URL schemes

#ifdef NEOMEDIA

NSString *const kSchemeFacebook = @"fb1053518941326361";
NSString *const kSchemeGooglePlus = @"com.samsao.winktalent";
NSString *const kTwitterConsumerSecret = @"CJy9NakTiTNlfFkKByYg2YJe1UzmWw43PN7qrKEixJOWFV2MYM";
NSString *const kTwitterConsumerKey = @"xWN8D23Qr6E0gJJFpthMXjbKX";
NSString *const kTwitterMediaUploadURL = @"https://upload.twitter.com/1.1/media/upload.json";
NSString *const kTwitterTweetUploadURL = @"https://api.twitter.com/1.1/statuses/update.json";
NSString *const kGoogleClientId = @"705787939641-q7u2cb9tbrd04ku4jc99h4bd5c1cs7bk.apps.googleusercontent.com";
NSString *const kAPIValue = @"psy02co49nais";
NSString *const kSegmentIoKey = @"GmFy6M3KXxHnHSKsIysy4QHHa3aIJL4Z";
#else
NSString *const kSchemeFacebook = @"fb465899996898725";
NSString *const kSchemeGooglePlus = @"com.samsao.winktalent";
NSString *const kTwitterConsumerSecret = @"CJy9NakTiTNlfFkKByYg2YJe1UzmWw43PN7qrKEixJOWFV2MYM";
NSString *const kTwitterConsumerKey = @"xWN8D23Qr6E0gJJFpthMXjbKX";
NSString *const kTwitterMediaUploadURL = @"https://upload.twitter.com/1.1/media/upload.json";
NSString *const kTwitterTweetUploadURL = @"https://api.twitter.com/1.1/statuses/update.json";
NSString *const kGoogleClientId = @"705787939641-q7u2cb9tbrd04ku4jc99h4bd5c1cs7bk.apps.googleusercontent.com";
NSString *const kAPIValue = @"joey1234";
NSString *const kSegmentIoKey = @"GmFy6M3KXxHnHSKsIysy4QHHa3aIJL4Z";
#endif
// NSString *const kAPIUrl = @"http://api-stage.usnap.com/v1";
NSString *const kAPIUrl = @"http://api.usnap.com/v1";
NSString *const kAPIKey = @"api_key";

#pragma mark - Notifications

NSString *const kSocialNetworkCellSwitchNotification = @"SOCIAL_NETWORK_CELL_SWITCH_NOTIFICATION";
NSString *const kCurrentUserStatusChanged = @"kCurrentUserStatusChanged";

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

NSString *const kFacebookSelected = @"kTokenFacebookSelected";
NSString *const kTwitterSelected = @"kTokenTwitterSelected";
NSString *const kGoogleSelected = @"kTokenGoogleSelected";

#pragma mark - NSUserDefaults

NSString *const kIsCameraRearFacing = @"kIsCameraRearFacing";
NSString *const kDevicePosition = @"kDevicePosition";
NSString *const kFlashState = @"kFlashState";
NSString *const kTorchState = @"kTorchState";

NSString *const kIsFirstLogin = @"kIsFirstLogin";
NSString *const kIsFirstLoginDate = @"kIsFirstLoginDate";
NSString *const kUSnapKeychainServiceKey = @"kUSnapKeychainServiceKey";

NSString *const kIsUserLoggedIn = @"kIsUserLoggedIn";
NSString *const kEmailLoggedString = @"kEmailLoggedString";
NSString *const kCurrentCampaignID = @"kCurrentCampaignID";

#pragma mark - Storyboard

NSString *const kCameraStoryboard = @"Camera";

#pragma mark - Segue

NSString *const kCameraContainerSegue = @"CAMERA_CONTAINER_SEGUE";

#pragma mark - Photos

NSInteger const kTopViewHeightConstraint = 40;
NSInteger const kConstraintOffset = 10;
NSInteger const kButtonWidthConstraint = 80;

#pragma mark - Cells
NSString *const kTopPhotosNib = @"SSOTopPhotosCollectionViewCell";
NSString *const kTopPhotosReusableId = @"topPhotosCell";
NSString *const kImageCollectionViewCell = @"imageCollectionViewCell";
NSString *const kImageCollectionViewCellNib = @"SSOImageCollectionViewCell";
NSString *const kPhotosCollectionViewCell = @"PhotosCollectionViewCell";
NSString *const kPhotosNibNameCollectionViewCell = @"SSOPhotosCollectionViewCell";

#pragma mark - Notifications

NSString *const kReturnToFanPageVC = @"ReturnToFanPageVC";
NSString *const kDeviceOrientationNotification = @"kDeviceOrientationNotification";
