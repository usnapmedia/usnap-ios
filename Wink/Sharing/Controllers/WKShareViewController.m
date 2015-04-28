
//
//  WKShareViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-08.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKShareViewController.h"
#import "WKMoviePlayerView.h"
#import "WKWinkConnect.h"
#import "WKSettingsViewController.h"
#import "WKNavigationController.h"
#import "WKVideoEditor.h"
#import "CWStatusBarNotification.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SSOSocialNetworkAPI+USnap.h"
#import <TwitterKit/TwitterKit.h>
#import <Masonry.h>
#import "SSSessionManager.h"
#import "WKWinkConnect.h"
#import <SVProgressHUD.h>
#import "SSOAlignedButtonsView.h"
#import <POP.h>
#import "SSOCustomSocialButton.h"
#import <SZTextView.h>
#import "SSORectangleSocialButton.h"
#import "SSOThemeHelper.h"

#define kOverlayViewAlpha 0.75
NSInteger const kNumberOfCharacters = 140;

typedef enum { WKShareViewControllerModeShare, WKShareViewControllerModeSharing, WKShareViewControllerModeShared } WKShareViewControllerMode;

@interface WKShareViewController () <WKMoviePlayerDelegate, POPAnimationDelegate, SocialNetworkDelegate>
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) WKMoviePlayerView *moviePlayerView;
@property(strong, nonatomic) UIImageView *overlayImageView;
@property(strong, nonatomic) WKVideoEditor *videoEditor;
@property(nonatomic) BOOL isTwitterConnected;
@property(nonatomic, strong) NSNumber *numberCharactersLeft;

// ContainerViews
@property(weak, nonatomic) IBOutlet UIView *previewImageContainerView;
@property(weak, nonatomic) IBOutlet UIView *buttonsContainerView;
@property(weak, nonatomic) IBOutlet UIView *mediaContainerView;

@property(weak, nonatomic) IBOutlet SZTextView *placeholderTextView;
@property(weak, nonatomic) IBOutlet UIButton *shareButton;
@property(weak, nonatomic) IBOutlet UIView *bottomView;
@property(strong, nonatomic) IBOutlet UIView *overlayView;
@property(weak, nonatomic) IBOutlet UILabel *labelCountCharacters;

// Social buttons
@property(weak, nonatomic) IBOutlet SSORectangleSocialButton *twitterButton;
@property(weak, nonatomic) IBOutlet SSORectangleSocialButton *facebookButton;
@property(weak, nonatomic) IBOutlet SSORectangleSocialButton *googleButton;

@property(strong, nonatomic) NSValue *bottomViewInitialCenter;

@end

@implementation WKShareViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numberCharactersLeft = [NSNumber numberWithInteger:kNumberOfCharacters];
    self.labelCountCharacters.text =
        [NSString stringWithFormat:@"%li %@", self.numberCharactersLeft.integerValue, NSLocalizedString(@"shareview.characterscount", nil)];
    self.labelCountCharacters.textColor = [SSOThemeHelper firstColor];

    self.buttonsContainerView.layer.cornerRadius = 4.0;
    self.mediaContainerView.layer.cornerRadius = 4.0;
    // Register for keyboard notifications
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tapGesture];

    // Setup the imageview
    if (self.image || self.modifiedImage) {
        self.imageView = [UIImageView new];
        UIImage *image = (self.modifiedImage) ? self.modifiedImage : self.image;
        self.imageView.image = image;
        [self.previewImageContainerView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.previewImageContainerView);
        }];
    }
    // Setup the movie player view
    else {
        self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:self.mediaURL];
        [self.previewImageContainerView addSubview:self.moviePlayerView];
        [self.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.previewImageContainerView);
        }];

        [self.moviePlayerView.player pause];
    }

    // Setup the overlay image view
    if (self.overlayImage) {
        self.overlayImageView = [UIImageView new];
        self.overlayImageView.image = self.overlayImage;
        [self.previewImageContainerView addSubview:self.overlayImageView];
        [self.overlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.previewImageContainerView);
        }];
    }

    // Setup the text view
    //  self.placeholderTextView.layer.cornerRadius = 2.0f;
    self.placeholderTextView.placeholderTextColor = [UIColor lightGreyTextColorWithAlpha:1.0f];
    self.placeholderTextView.textColor = [UIColor blackColor];
    self.placeholderTextView.placeholder = NSLocalizedString(@"shareview.textview.placeholder.text", @"");
    self.placeholderTextView.fadeTime = 0.2;

    // Setup the share button
    self.shareButton.layer.cornerRadius = 2.0f;

    [SSOSocialNetworkAPI sharedInstance].delegate = self;

    [self.view insertSubview:self.overlayView belowSubview:self.bottomView];

    // Update UI
    // [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Animate the display of the topView after all layouts have been calculated (fix iPhone 6+ loop bug)
    [UIView animateWithDuration:0.5
                     animations:^{
                       self.facebookButton.alpha = 1;
                       self.twitterButton.alpha = 1;
                       self.googleButton.alpha = 1;
                       [self setupSocialButtons];
                     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.facebookButton.alpha = 0;
    self.twitterButton.alpha = 0;
    self.googleButton.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Getters

/**
 *  Lazy instanciation
 */
- (NSValue *)bottomViewInitialCenter {

    if (!_bottomViewInitialCenter) {
        _bottomViewInitialCenter = [NSValue valueWithCGPoint:self.bottomView.center];
    }

    return _bottomViewInitialCenter;
}

/**
 *  Lazy instanciation
 */
- (UIView *)overlayView {

    if (!_overlayView) {
        // Set the overlay view
        _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0;
        // Add tap recognizer to dismiss the keyboard
        [_overlayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewTouched:)]];
    }

    return _overlayView;
}

#pragma mark - Utilities

- (void)setUI {

    [UIView animateWithDuration:2
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
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

/**
 *  Setup the edit buttons
 */
- (void)setupSocialButtons {

    [self.facebookButton setState:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:facebookSocialNetwork]
                 forSocialNetwork:facebookSocialNetwork];
    self.facebookButton.tag = facebookSocialNetwork;

    [self.facebookButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.twitterButton setState:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:twitterSocialNetwork]
                forSocialNetwork:twitterSocialNetwork];

    self.twitterButton.tag = twitterSocialNetwork;
    [self.twitterButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.googleButton setState:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:googleSocialNetwork]
               forSocialNetwork:googleSocialNetwork];

    self.googleButton.tag = googleSocialNetwork;
    [self.googleButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];

    //    SSOCustomSocialButton *facebookButton =
    //        [[SSOCustomSocialButton alloc] initWithSocialNetwork:facebookSocialNetwork
    //                                                       state:[[SSOSocialNetworkAPI sharedInstance]
    //                                                       isUsnapConnectedToSocialNetwork:facebookSocialNetwork]];
    //    facebookButton.tag = facebookSocialNetwork;
    //
    //    [facebookButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    SSOCustomSocialButton *twitterButton =
    //        [[SSOCustomSocialButton alloc] initWithSocialNetwork:twitterSocialNetwork
    //                                                       state:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:twitterSocialNetwork]];
    //    twitterButton.tag = twitterSocialNetwork;
    //    [twitterButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    SSOCustomSocialButton *googlePlusButton =
    //        [[SSOCustomSocialButton alloc] initWithSocialNetwork:googleSocialNetwork
    //                                                       state:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:googleSocialNetwork]];
    //    googlePlusButton.tag = googleSocialNetwork;
    //    [googlePlusButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];

    // [self.topView setupViewforOrientation:[UIDevice currentDevice].orientation withArrayButtons:@[ facebookButton, twitterButton, googlePlusButton ]];
}

- (void)dismissKeyboard {

    [self.placeholderTextView resignFirstResponder];
}

#pragma mark - Action

- (void)overlayViewTouched:(id)sender {
    if ([self.placeholderTextView isFirstResponder]) {
        [self.placeholderTextView resignFirstResponder];
    }
}

#pragma mark - Animation

- (void)animatedViewForKeyboardWithSize:(CGSize)size shouldSlideUp:(BOOL)isSlidingUp {

    if (isSlidingUp) {
        [self.overlayView setHidden:NO];
        // Set the animation to slide the view up
        POPSpringAnimation *moveUpAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        // We need to use the initial center to move with the auto-correct keyboard show/hide
        CGPoint initialCenter = [self.bottomViewInitialCenter CGPointValue];
        CGPoint center = CGPointMake(initialCenter.x, initialCenter.y - size.height);
        moveUpAnimation.toValue = [NSValue valueWithCGPoint:center];
        [self.bottomView pop_addAnimation:moveUpAnimation forKey:@"moveUp"];
        // Set the animation to fade the view in
        POPSpringAnimation *fadeInAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        fadeInAnimation.toValue = [NSNumber numberWithFloat:kOverlayViewAlpha];
        fadeInAnimation.delegate = self;
        fadeInAnimation.name = @"fadeInAnimation";
        [self.overlayView pop_addAnimation:fadeInAnimation forKey:@"fadeIn"];

    } else {
        // Set the animation to side the view down
        POPSpringAnimation *moveDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        moveDownAnimation.toValue = self.bottomViewInitialCenter;
        [self.bottomView pop_addAnimation:moveDownAnimation forKey:@"moveDown"];
        // Set the animation to fade out the background view
        POPSpringAnimation *fadeOutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        fadeOutAnimation.toValue = [NSNumber numberWithFloat:0];
        fadeOutAnimation.delegate = self;
        fadeOutAnimation.name = @"fadeOutAnimation";
        [self.overlayView pop_addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    }
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    // Check if it's a fade out animation
    if ([anim.name isEqualToString:@"fadeOutAnimation"]) {
        // Hide the view after the animation
        [self.overlayView setHidden:YES];
    }
}
#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {

    CGSize keyboardFrameBegin = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [self animatedViewForKeyboardWithSize:keyboardFrameBegin shouldSlideUp:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardFrameBegin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [self animatedViewForKeyboardWithSize:keyboardFrameBegin shouldSlideUp:NO];
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

/**
 *  Return the image with the modifs made
 *
 *  @return <#return value description#>
 */
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

/**
 *  Post the image to the backend
 */
- (void)post {
    [self.placeholderTextView resignFirstResponder];
    [self savePostToCameraRoll];

    [SVProgressHUD showWithStatus:@"uploading"];

    [WKWinkConnect winkConnectPostImageToBackend:[self editedImage]
        withText:self.placeholderTextView.text
        andMeta:@{
            @"something" : @"here"
        }
        success:^(AFHTTPRequestOperation *operation, id responseObject) {

          // @FIXME
          [SVProgressHUD showSuccessWithStatus:@"Image posted"];
          [self.navigationController popToRootViewControllerAnimated:YES];
          NSLog(@"shared with succcess");

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          //@FIXME
          //@TODO: Should be handled generally
          [SVProgressHUD showErrorWithStatus:error.localizedDescription];

        }];
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

    [self post];
}
- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Action called when the user press on a social network button
 *
 *  @param button the button
 */
- (void)touchedSocialNetworkButton:(SSOCustomSocialButton *)button {
    // Disable interactions with the button so the user can't call 2 times the same action
    if (button.isSelected) {
        // User was already
        [[SSOSocialNetworkAPI sharedInstance] usnapDisconnectToSocialNetwork:button.socialNetwork];
        [button setSelected:NO];
    } else {
        [button setUserInteractionEnabled:NO];
        [self performSelector:@selector(reEnableInteractionSocialButton:) withObject:button afterDelay:1];
        [[SSOSocialNetworkAPI sharedInstance] usnapConnectToSocialNetwork:button.socialNetwork];
        [button setSelected:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:button.socialNetwork]];
    }
}

/**
 *  Simple method called as selector to enable button interaction
 *
 *  @param button the social network button
 */
- (void)reEnableInteractionSocialButton:(SSOCustomSocialButton *)button {

    [button setUserInteractionEnabled:YES];
}

#pragma mark - SocialNetworkDelegate

- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidFinishLoginWithError:(NSError *)error {

    for (UIView *view in self.buttonsContainerView.subviews) {
        if ([view isKindOfClass:[SSORectangleSocialButton class]]) {
            // Cast the view to get the social network
            SSORectangleSocialButton *socialButton = (SSORectangleSocialButton *)view;
            if (socialButton.socialNetwork == socialNetwork) {
                // The interaction was disabled on touch, we need to reset it after the network response
                [socialButton setUserInteractionEnabled:YES];
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    // Disconnect the social network to reset it's value
                    [[SSOSocialNetworkAPI sharedInstance] usnapDisconnectToSocialNetwork:socialButton.socialNetwork];
                    socialButton.selected = NO;
                } else {
                    // If there is no error, it means the user is connected and we can select the button to show him.
                    socialButton.selected = YES;
                }
            }
        }
    }
}

- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidCancelLogin:(NSError *)error {

    for (UIView *view in self.buttonsContainerView.subviews) {
        if ([view isKindOfClass:[SSORectangleSocialButton class]]) {
            // Cast the view to get the social network
            SSORectangleSocialButton *socialButton = (SSORectangleSocialButton *)view;
            // The interaction was disabled on touch, we need to reset it after the network response
            [socialButton setUserInteractionEnabled:YES];
            if (socialButton.socialNetwork == socialNetwork) {
                socialButton.selected = NO;

                [[SSOSocialNetworkAPI sharedInstance] usnapDisconnectToSocialNetwork:socialButton.socialNetwork];
            }
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    NSNumber *numberCharactersLeft = [NSNumber numberWithInteger:(self.numberCharactersLeft.integerValue - textView.text.length)];

    self.labelCountCharacters.text =
        [NSString stringWithFormat:@"%li %@", numberCharactersLeft.integerValue, NSLocalizedString(@"shareview.characterscount", nil)];

    NSLog(@"textView %li", textView.text.length);
}

@end
