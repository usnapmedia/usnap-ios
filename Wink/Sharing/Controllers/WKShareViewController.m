
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
NSInteger const kMaxNumberOfCharacters = 140;

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

@property(weak, nonatomic) IBOutlet UIButton *OKButton;
@property(weak, nonatomic) IBOutlet SZTextView *placeholderTextView;
@property(weak, nonatomic) IBOutlet UIButton *shareButton;
@property(weak, nonatomic) IBOutlet UIView *bottomView;
@property(strong, nonatomic) IBOutlet UIView *overlayView;
@property(weak, nonatomic) IBOutlet UILabel *labelCountCharacters;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;

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
    self.numberCharactersLeft = [NSNumber numberWithInteger:kMaxNumberOfCharacters];
    self.labelCountCharacters.text =
        [NSString stringWithFormat:@"%li %@", self.numberCharactersLeft.integerValue, NSLocalizedString(@"shareview.characterscount", nil)];
    self.labelCountCharacters.font = [SSOThemeHelper avenirLightFontWithSize:14];
    self.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:17];
    self.twitterButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
    self.facebookButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
    self.googleButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
    self.shareButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
    self.placeholderTextView.font = [SSOThemeHelper avenirLightFontWithSize:14];
    [self.shareButton setTitle:NSLocalizedString(@"shareView.shareButton", nil) forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [SSOThemeHelper firstColor];
    self.titleLabel.text = NSLocalizedString(@"shareview.title", nil);
    self.labelCountCharacters.textColor = [SSOThemeHelper firstColor];
    self.buttonsContainerView.layer.cornerRadius = 4.0;
    self.mediaContainerView.layer.cornerRadius = 4.0;
    self.bottomView.layer.cornerRadius = 4.0;
    self.OKButton.tintColor = [SSOThemeHelper firstColor];
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    // Setup the imageview
    if (self.image || self.modifiedImage) {
        self.imageView = [UIImageView new];
        self.imageView.image = (self.modifiedImage) ? self.modifiedImage : self.image;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.previewImageContainerView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.previewImageContainerView);
        }];
    }
    // Setup the movie player view
    else {
        //        NSLog(@"%@", [SSSessionManager sharedInstance].lastVideoURL);
        self.mediaURL = [SSSessionManager sharedInstance].lastVideoURL;
        self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:self.mediaURL];
        self.moviePlayerView.delegate = self;
        self.moviePlayerView.frame = self.previewImageContainerView.bounds;
        self.moviePlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.moviePlayerView.clipsToBounds = YES;
        [self.previewImageContainerView addSubview:self.moviePlayerView];
        [self.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.previewImageContainerView);
        }];
        [self.moviePlayerView.player play];
    }
    // Setup the overlay image view
    if (self.overlayImage) {
        self.overlayImageView = [UIImageView new];
        self.overlayImageView.image = self.overlayImage;
        self.overlayImage = self.overlayImageView.image;
        self.overlayImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.previewImageContainerView addSubview:self.overlayImageView];
        //        NSLog(@"%@", self.previewImageContainerView);
        [self.overlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.previewImageContainerView);
        }];
    }
    // Setup the text view
    //  self.placeholderTextView.layer.cornerRadius = 2.0f;
    self.placeholderTextView.placeholderTextColor = [UIColor lightGrayColor];
    self.placeholderTextView.textColor = [UIColor blackColor];
    self.placeholderTextView.placeholder = NSLocalizedString(@"shareview.textview.placeholder.text", @"");
    self.placeholderTextView.fadeTime = 0.2;
    self.placeholderTextView.backgroundColor = [UIColor whiteColor];
    // Setup the share button
    self.shareButton.layer.cornerRadius = 2.0f;
    [SSOSocialNetworkAPI sharedInstance].delegate = self;
    [self.view insertSubview:self.overlayView belowSubview:self.mediaContainerView];
    // Update UI
    // [self updateUI];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}
- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer {
    [self.moviePlayerView.player play];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
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
                       self.shareButton.backgroundColor = [SSOThemeHelper firstColor];

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

    self.googleButton.hidden = YES;
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
    [UIView animateWithDuration:0.5f
        animations:^{
          self.overlayView.alpha = 0.4;
          self.OKButton.alpha = 1.0f;
        }
        completion:^(BOOL finished) {
          [self.OKButton setUserInteractionEnabled:YES];
        }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.5f
        animations:^{
          self.overlayView.alpha = 0;
          self.OKButton.alpha = 0;
        }
        completion:^(BOOL finished) {
          [self.OKButton setUserInteractionEnabled:NO];
        }];
}

#pragma mark - Update UI

/**
 *  Return the image with the modifs made
 *
 *  @return <#return value description#>
 */

- (UIImage *)editedImage {

    if (self.image) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
        view.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.imageView.image;
        [view addSubview:imageView];

        UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:view.bounds];
        overlayImageView.contentMode = UIViewContentModeScaleAspectFit;
        overlayImageView.image = self.overlayImage;
        [view addSubview:overlayImageView];

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // Change image to PNG

        NSData *pngdata = UIImagePNGRepresentation(snapshot); // PNG wrap
        UIImage *pngImage = [UIImage imageWithData:pngdata];

        CGFloat maxSize = MAX(pngImage.size.height, pngImage.size.width);
        CGFloat witdh = pngImage.size.width;
        CGFloat height = pngImage.size.height;
        if (maxSize > 1000) {
            CGFloat percentage = maxSize / 1000;
            witdh = witdh / percentage;
            height = height / percentage;
            pngImage = [self resizeImage:pngImage resizeSize:CGSizeMake(witdh, height)];
        }
        return pngImage;
    }
    return nil;
}

- (UIImage *)resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size {
    CGFloat actualHeight = orginalImage.size.height;
    CGFloat actualWidth = orginalImage.size.width;
    //  if(actualWidth <= size.width && actualHeight<=size.height)
    //  {
    //      return orginalImage;
    //  }
    float oldRatio = actualWidth / actualHeight;
    float newRatio = size.width / size.height;
    if (oldRatio < newRatio) {
        oldRatio = size.height / actualHeight;
        actualWidth = oldRatio * actualWidth;
        actualHeight = size.height;
    } else {
        oldRatio = size.width / actualWidth;
        actualHeight = oldRatio * actualHeight;
        actualWidth = size.width;
    }

    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [orginalImage drawInRect:rect];
    orginalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return orginalImage;
}

#pragma mark - Post

/**
 *  Post the image to the backend
 */
- (void)post {
    [self.placeholderTextView resignFirstResponder];
    [SVProgressHUD showWithStatus:@"uploading" maskType:SVProgressHUDMaskTypeBlack];

    if (!self.mediaURL) {
        [WKWinkConnect winkConnectPostImageToBackend:[self editedImage]
            withText:self.placeholderTextView.text
            //@TODO
            andMeta:@{
                @"something" : @"here"
            }
            success:^(AFHTTPRequestOperation *operation, id responseObject) {

              // @FIXME
              [SVProgressHUD showSuccessWithStatus:@"Image posted"];
              [[NSNotificationCenter defaultCenter] postNotificationName:kReturnToFanPageVC object:nil userInfo:nil];
             [self dismissViewControllerAnimated:YES completion:^{
                 [self.parentCameraNavigationController dismissViewControllerAnimated:YES completion:nil];
             }];
              NSLog(@"%@", responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //@FIXME
              //@TODO: Should be handled generally
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];

            }];
    } else {
        [WKWinkConnect winkConnectPostVideoToBackend:self.mediaURL
            withText:self.placeholderTextView.text
            overlayImage:self.overlayImageView.image
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // @FIXME
              [SVProgressHUD showSuccessWithStatus:@"Video posted"];
              [[NSNotificationCenter defaultCenter] postNotificationName:kReturnToFanPageVC object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.parentCameraNavigationController dismissViewControllerAnimated:YES completion:nil];
                }];

              NSLog(@"%@", responseObject);

            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //@FIXME
              //@TODO: Should be handled generally
              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
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
- (IBAction)OKButtonTouched:(id)sender {
    if ([self.placeholderTextView isFirstResponder]) {
        [self.placeholderTextView resignFirstResponder];
    }
}

- (IBAction)shareButtonTouched:(id)sender {

    [self post];
}
- (IBAction)backButtonTouched:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:true completion:nil];
}

/**
 *  Action called when the user press on a social network button
 *
 *  @param button the button
 */
- (void)touchedSocialNetworkButton:(SSORectangleSocialButton *)button {
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

    // Check if the user can still add characters. If he can't remove them
    if (numberCharactersLeft.intValue <= 0) {
        textView.text = [textView.text substringToIndex:[textView.text length] - abs(numberCharactersLeft.intValue)];
        self.labelCountCharacters.text = [NSString stringWithFormat:@"0 %@", NSLocalizedString(@"shareview.characterscount", nil)];
    } else {
        self.labelCountCharacters.text =
            [NSString stringWithFormat:@"%li %@", numberCharactersLeft.integerValue, NSLocalizedString(@"shareview.characterscount", nil)];
    }
    //    NSLog(@"textView %li", textView.text.length);
}

@end
