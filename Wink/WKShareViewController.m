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
#import "WKUser.h"
#import "WKSettingsViewController.h"
#import "WKNavigationController.h"
#import "WKVideoEditor.h"
#import "CWStatusBarNotification.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "WKSocialNetworkHelper.h"
#import <TwitterKit/TwitterKit.h>

typedef enum { WKShareViewControllerModeShare, WKShareViewControllerModeSharing, WKShareViewControllerModeShared } WKShareViewControllerMode;

@interface WKShareViewController () <WKMoviePlayerDelegate>
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) WKMoviePlayerView *moviePlayerView;
@property(strong, nonatomic) UIImageView *overlayImageView;
@property(strong, nonatomic) WKVideoEditor *videoEditor;
@property(nonatomic) WKShareViewControllerMode mode;
@property(nonatomic) BOOL isTwitterConnected;

@end

@implementation WKShareViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Get the frame for the media
    CGFloat margin = 2.0f;
    CGRect rect = CGRectMake(margin, margin, self.mediaContainerView.frame.size.width - (2 * margin), self.mediaContainerView.frame.size.height - (2 * margin));

    // Setup the imageview
    if (self.image || self.modifiedImage) {
        UIImage *image = (self.modifiedImage) ? self.modifiedImage : self.image;
        self.imageView = [[UIImageView alloc] initWithFrame:rect];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = image;
        [self.mediaContainerView addSubview:self.imageView];
    }
    // Setup the movie player view
    else {
        self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:self.mediaURL];
        self.moviePlayerView.delegate = self;
        self.moviePlayerView.frame = rect;
        self.moviePlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.moviePlayerView.clipsToBounds = YES;
        [self.mediaContainerView addSubview:self.moviePlayerView];
    }

    // Setup the overlay image view
    if (self.overlayImage) {
        self.overlayImageView = [[UIImageView alloc] initWithFrame:rect];
        self.overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.overlayImageView.clipsToBounds = YES;
        self.overlayImageView.image = self.overlayImage;
        [self.mediaContainerView addSubview:self.overlayImageView];
    }

    // Setup the text view
    self.placeholderTextView.layer.cornerRadius = 2.0f;
    self.placeholderTextView.placeholderColor = [UIColor lightGreyTextColorWithAlpha:1.0f];
    self.placeholderTextView.textColor = [UIColor lightGreyTextColorWithAlpha:1.0f];
    self.placeholderTextView.placeholder = NSLocalizedString(@"Say something... (ex. Sunday #selfie)", @"");

    // Setup the share button
    self.shareButton.layer.cornerRadius = 2.0f;

    // Setup the scrollview content size
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);

    // Setup the gesture to dismiss the keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    [self.scrollView addGestureRecognizer:tapGesture];

    // Update UI
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Set if the scroll view can be scrolled
    self.scrollView.scrollEnabled = (self.scrollView.contentSize.height > self.scrollView.frame.size.height);

    // Play the movie player
    [self.moviePlayerView.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.moviePlayerView.player pause];
}

#pragma mark - Set Share Mode

- (void)setMode:(WKShareViewControllerMode)mode {
    if (_mode != mode) {
        _mode = mode;

        [self updateUI];
    }
}

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

    [self.scrollView scrollRectToVisible:CGRectMake(0.0f, self.scrollView.contentSize.height - self.view.frame.size.height, self.scrollView.frame.size.width,
                                                    self.view.frame.size.height)
                                animated:YES];
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:animationCurve
                     animations:^{ self.view.transform = CGAffineTransformMakeTranslation(0.0f, -size.height); }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];

    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:animationCurve
                     animations:^{ self.view.transform = CGAffineTransformIdentity; }
                     completion:nil];
}

#pragma mark - Update UI

- (void)updateUI {

    // Setup the social media button
    [self.socialMediaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"Sharing to", @""), [self numberSocialNetworkConnected],
                                                                NSLocalizedString(@"social networks", @"")]
                            forState:UIControlStateNormal];

    CGFloat animationDuration = 0.3f;

    switch (self.mode) {
    case WKShareViewControllerModeShare: {
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:1.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{

                             self.backButton.transform = CGAffineTransformIdentity;
                             self.backButton.alpha = 1.0f;
                             self.placeholderTextView.backgroundColor = [UIColor whiteColor];
                             self.placeholderTextView.userInteractionEnabled = YES;
                             self.placeholderTextView.hidden = NO;
                             self.socialMediaContainerView.transform = CGAffineTransformIdentity;
                             self.socialMediaContainerView.alpha = 1.0f;

                             self.shareButton.layer.borderColor = [UIColor clearColor].CGColor;
                             self.shareButton.layer.borderWidth = 0.0f;
                             self.shareButton.backgroundColor = [UIColor purpleColorWithAlpha:1.0f];

                             NSMutableAttributedString *shareButtonAttrString =
                                 [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Share your wink", @"").uppercaseString];
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
    } break;

    case WKShareViewControllerModeSharing: {
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:1.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{

                             self.backButton.transform =
                                 CGAffineTransformMakeTranslation(-self.backButton.center.x - roundf(self.backButton.frame.size.width / 2.0f), 0.0f);
                             self.backButton.alpha = 0.0f;
                             self.placeholderTextView.backgroundColor = [UIColor clearColor];
                             self.placeholderTextView.userInteractionEnabled = NO;
                             self.placeholderTextView.hidden = !(self.placeholderTextView.text.length > 0);
                             self.socialMediaContainerView.transform = CGAffineTransformMakeTranslation(0.0f, self.socialMediaContainerView.frame.size.height);
                             self.socialMediaContainerView.alpha = 0.0f;

                             self.shareButton.layer.borderColor = [UIColor purpleColorWithAlpha:1.0f].CGColor;
                             self.shareButton.layer.borderWidth = 2.0f;
                             self.shareButton.backgroundColor = [UIColor clearColor];

                             NSMutableAttributedString *shareButtonAttrString =
                                 [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Sharing...", @"").uppercaseString];
                             [shareButtonAttrString addAttribute:NSKernAttributeName
                                                           value:[NSNumber numberWithInteger:2]
                                                           range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                             [shareButtonAttrString addAttribute:NSForegroundColorAttributeName
                                                           value:[UIColor purpleColorWithAlpha:1.0f]
                                                           range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                             [self.shareButton setAttributedTitle:shareButtonAttrString forState:UIControlStateNormal];

                             self.shareButton.userInteractionEnabled = NO;

                         }
                         completion:nil];
    } break;

    case WKShareViewControllerModeShared: {
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:1.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{

                             self.backButton.transform =
                                 CGAffineTransformMakeTranslation(-self.backButton.center.x - roundf(self.backButton.frame.size.width / 2.0f), 0.0f);
                             self.backButton.alpha = 0.0f;
                             self.placeholderTextView.backgroundColor = [UIColor clearColor];
                             self.placeholderTextView.userInteractionEnabled = NO;
                             self.placeholderTextView.hidden = !(self.placeholderTextView.text.length > 0);
                             self.socialMediaContainerView.transform = CGAffineTransformMakeTranslation(0.0f, self.socialMediaContainerView.frame.size.height);
                             self.socialMediaContainerView.alpha = 0.0f;

                             self.shareButton.layer.borderColor = [UIColor clearColor].CGColor;
                             self.shareButton.layer.borderWidth = 0.0f;
                             self.shareButton.backgroundColor = [UIColor greenColorWithAlpha:1.0f];

                             NSMutableAttributedString *shareButtonAttrString =
                                 [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"D-D-DONE!", @"").uppercaseString];
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
    } break;

    default:
        break;
    }
}

#pragma mark - Movie View Methods

- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer {
    [self.moviePlayerView.player play];
}

#pragma mark - Scrollview Tapped

- (void)scrollViewTapped {
    [self.placeholderTextView resignFirstResponder];
}

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
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(),
                                               ^{ [notification dismissNotification]; });
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

    // Check to see if it's image first
    if ([self editedImage]) {
        [self postImageOnSelectedSocialNetworks];
    } else { // Else it's a movie, no need to send the video as it will be sent after the video edition and save in the
             // Camera roll is done.
    }
    self.mode = WKShareViewControllerModeShared;
    [self updateUI];
}

#pragma mark - Social networks

/**
 *  Check where the user is connected and send to the proper channels
 */
- (void)postImageOnSelectedSocialNetworks {
    // If the user activated Twitter, post it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSwitchValue]) {
        [WKSocialNetworkHelper postTweetWithMessage:self.placeholderTextView.text andImage:[self editedImage]];
    }
    // If the user activated Facebook, post it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
        [WKSocialNetworkHelper postImageToFacebookWithMessage:self.placeholderTextView.text andImage:[self editedImage]];
    }
}

/**
 *  Check where the user is connected and send to the proper channels
 */
- (void)postVideoOnSelectedSocialNetworks:(NSData *)videoData {
    // If the user activated Facebook, post it
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
        [WKSocialNetworkHelper postVideoToFacebookWithMessage:self.placeholderTextView.text andVideo:videoData];
    }
}

#pragma mark - Button Actions

- (IBAction)shareButtonTouched:(id)sender {
    if (self.mode == WKShareViewControllerModeShare) {
        [self post];
    } else if (self.mode == WKShareViewControllerModeShared) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)socialMediaButtonTouched:(id)sender {
    WKSettingsViewController *controller = [[WKSettingsViewController alloc] initWithNibName:@"WKSettingsViewController" bundle:nil];
    WKNavigationController *navController = [[WKNavigationController alloc] initWithRootViewController:controller];
    if (!self.isPhone) {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self.navigationController.visibleViewController presentViewController:navController animated:YES completion:nil];
}

@end
