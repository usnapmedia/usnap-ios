//
//  WKShareViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-08.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKShareViewController.h"
#import "GCPlaceholderTextView.h"
#import "WKMoviePlayerView.h"
#import "WKWinkConnect.h"
#import "WKSettingsViewController.h"
#import "WKNavigationController.h"
#import "WKVideoEditor.h"
#import "CWStatusBarNotification.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SSOSocialNetworkAPI.h"
#import <TwitterKit/TwitterKit.h>
#import <Masonry.h>
#import "SSSessionManager.h"
#import "WKWinkConnect.h"
#import <SVProgressHUD.h>
typedef enum { WKShareViewControllerModeShare, WKShareViewControllerModeSharing, WKShareViewControllerModeShared } WKShareViewControllerMode;

@interface WKShareViewController () <WKMoviePlayerDelegate>
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) WKMoviePlayerView *moviePlayerView;
@property(strong, nonatomic) UIImageView *overlayImageView;
@property(strong, nonatomic) WKVideoEditor *videoEditor;
//@property(nonatomic) WKShareViewControllerMode mode;
@property(nonatomic) BOOL isTwitterConnected;

@property(weak, nonatomic) IBOutlet UIView *mediaContainerView;
@property(weak, nonatomic) IBOutlet GCPlaceholderTextView *placeholderTextView;
@property(weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation WKShareViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Setup the imageview
    if (self.image || self.modifiedImage) {
        self.imageView = [UIImageView new];
        UIImage *image = (self.modifiedImage) ? self.modifiedImage : self.image;
        self.imageView.image = image;
        [self.mediaContainerView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.mediaContainerView);
        }];
    }
    // Setup the movie player view
    else {
        self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:self.mediaURL];
        [self.mediaContainerView addSubview:self.moviePlayerView];
        [self.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.mediaContainerView);
        }];

        [self.moviePlayerView.player pause];
    }

    // Setup the overlay image view
    if (self.overlayImage) {
        self.overlayImageView = [UIImageView new];
        self.overlayImageView.image = self.overlayImage;
        [self.mediaContainerView addSubview:self.overlayImageView];
        [self.overlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.mediaContainerView);
        }];
    }

    // Setup the text view
    self.placeholderTextView.layer.cornerRadius = 2.0f;
    self.placeholderTextView.placeholderColor = [UIColor lightGreyTextColorWithAlpha:1.0f];
    self.placeholderTextView.textColor = [UIColor lightGreyTextColorWithAlpha:1.0f];
    //    self.placeholderTextView.placeholder = NSLocalizedString(@"Say something... (ex. Sunday #selfie)", @"");

    // Setup the share button
    self.shareButton.layer.cornerRadius = 2.0f;

    // Update UI
    // [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Utilities

- (void)setUI {

    [UIView animateWithDuration:2
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                       //                           self.backButton.transform = CGAffineTransformIdentity;
                       //                           self.backButton.alpha = 1.0f;
                       //                           self.placeholderTextView.backgroundColor = [UIColor whiteColor];
                       //                           self.placeholderTextView.userInteractionEnabled = YES;
                       //                           self.placeholderTextView.hidden = NO;
                       //                           self.socialMediaContainerView.transform = CGAffineTransformIdentity;
                       //                           self.socialMediaContainerView.alpha = 1.0f;

                       self.shareButton.layer.borderColor = [UIColor clearColor].CGColor;
                       self.shareButton.layer.borderWidth = 0.0f;
                       self.shareButton.backgroundColor = [UIColor purpleColorWithAlpha:1.0f];

                       NSMutableAttributedString *shareButtonAttrString =
                           [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Share", @"").uppercaseString];
                       [shareButtonAttrString addAttribute:NSKernAttributeName
                                                     value:[NSNumber numberWithInteger:2]
                                                     range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                       [shareButtonAttrString addAttribute:NSForegroundColorAttributeName
                                                     value:[UIColor whiteColor]
                                                     range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                       [self.shareButton setAttributedTitle:shareButtonAttrString forState:UIControlStateNormal];

                       self.shareButton.userInteractionEnabled = YES;

                     }
                     completion:nil];
}

#pragma mark - Set Share Mode

/**
 *  Check the number of social networks the user is currently connected on
 *
 *  @return the number of connected social networks
 */
- (NSNumber *)numberSocialNetworkConnected {

    int numberNetworks = 0;

    if ([self editedImage]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kGooglePlusSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kTumblrSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kInstagramSwitchValue]) {
            numberNetworks++;
        }
        // Else it's a video, only calculate the number of social networks supporting hosting videos
    } else if (self.mediaURL) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kGooglePlusSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kTumblrSwitchValue]) {
            numberNetworks++;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kInstagramSwitchValue]) {
            numberNetworks++;
        }
    }
    NSNumber *numberNetworksReturned = [NSNumber numberWithInt:numberNetworks];

    return numberNetworksReturned;
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGSize size = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:animationCurve
                     animations:^{
                       self.view.transform = CGAffineTransformMakeTranslation(0.0f, -size.height);
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];

    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:animationCurve
                     animations:^{
                       self.view.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}

#pragma mark - Update UI

#pragma mark - Save Post to Camera Roll

- (void)savePostToCameraRoll {
    // In case it's an image
    if (self.image) {

        // Add the overlay to the image and save it
        UIImageWriteToSavedPhotosAlbum([self editedImage], nil, nil, nil);

        // Create the notification
        CWStatusBarNotification *notification = [[CWStatusBarNotification alloc] init];
        [notification displayNotificationWithMessage:NSLocalizedString(@"Saved to your camera roll!", @"").uppercaseString forDuration:2.0f];
    } else if (self.mediaURL) { // In case it's a video

        // Create the notification
        CWStatusBarNotification *notification = [[CWStatusBarNotification alloc] init];
        [notification displayNotificationWithMessage:NSLocalizedString(@"Saving to camera roll...", @"").uppercaseString completion:nil];

        AVAsset *asset = [AVAsset assetWithURL:self.mediaURL];
        self.videoEditor = [[WKVideoEditor alloc] init];
        [self.videoEditor exportVideo:asset
                              overlay:self.overlayImage
                            completed:^(BOOL success) {
                              NSString *title = @"";
                              if (success) {
                                  // Share video here
                                  title = NSLocalizedString(@"Saved to your camera roll!", @"").uppercaseString;

                                  // The video with the overlay on
                                  NSData *videoData = [NSData dataWithContentsOfURL:self.videoEditor.urlOfVideoInCameraRoll];
                                  // Post the video on the social networks selected
                                  // @TODO We could make this a bit cleaner
                                  [self postVideoOnSelectedSocialNetworks:videoData];

                              } else {
                                  title = NSLocalizedString(@"Error saving the video to your camera roll", @"").uppercaseString;
                              }
                              // Display the notification for 2 seconds
                              notification.notificationLabel.text = title;
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [notification dismissNotification];
                              });
                            }];
    }
}

// Return the image with the modifs made
- (UIImage *)editedImage {

    if (self.image) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor blackColor];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = (self.modifiedImage) ? self.modifiedImage : self.image;
        [view addSubview:imageView];

        UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:view.bounds];
        overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
        overlayImageView.image = self.overlayImage;
        [view addSubview:overlayImageView];

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshot;
    }
    return nil;
}

#pragma mark - Post

- (void)post {
    [self.placeholderTextView resignFirstResponder];
    [self savePostToCameraRoll];

    [SVProgressHUD showWithStatus:@"uploading"];

    [WKWinkConnect winkConnectPostImageToBackend:[self editedImage]
        withText:@"TEstytext"
        andMeta:@{
            @"something" : @"here"
        }
        success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [SVProgressHUD setStatus:@"Success"];

          [self.navigationController popToRootViewControllerAnimated:YES];

          NSLog(@"shared with succcess");

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {

          [SVProgressHUD showWithStatus:@"Failed, backend error can't do anything about it until fixed"];

          NSLog(@"share failed because : %@", error);
            
            [SVProgressHUD dismiss];

        }];

    // Check to see if it's image first
    if ([self editedImage]) {
        [self postImageOnSelectedSocialNetworks];
    } else { // Else it's a movie, no need to send the video as it will be sent after the video edition and save in the
             // Camera roll is done.
    }
}

#pragma mark - Social networks

/**
 *  Check where the user is connected and send to the proper channels
 */
- (void)postImageOnSelectedSocialNetworks {
    // If the user activated Twitter, post it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSwitchValue]) {
        [SSOSocialNetworkAPI postTweetWithMessage:self.placeholderTextView.text andImage:[self editedImage]];
    }
    // If the user activated Facebook, post it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
        [SSOSocialNetworkAPI postImageToFacebookWithMessage:self.placeholderTextView.text andImage:[self editedImage]];
    }
}

/**
 *  Check where the user is connected and send to the proper channels
 */
- (void)postVideoOnSelectedSocialNetworks:(NSData *)videoData {
    // If the user activated Facebook, post it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
        [SSOSocialNetworkAPI postVideoToFacebookWithMessage:self.placeholderTextView.text andVideo:videoData];
    }
}

#pragma mark - Button Actions

- (IBAction)shareButtonTouched:(id)sender {

    // TODO: Temporary fixes because problem with backend
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] valueForKey:kEmailLoggedString];

    NSString *password = [SSSessionManager getSecuredPasswordForAccount:userAccount];

    NSLog(@"user : %@ and pass :%@", userAccount, password);

    [WKWinkConnect winkConnectLoginWithUsername:userAccount
        password:password
        meta:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [SVProgressHUD showWithStatus:@"Connecting"];

          [self post];

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [SVProgressHUD showWithStatus:@"Error connection"];
        }];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
