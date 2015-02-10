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

typedef enum {
    WKShareViewControllerModeShare,
    WKShareViewControllerModeSharing,
    WKShareViewControllerModeShared
} WKShareViewControllerMode;

@interface WKShareViewController () <WKMoviePlayerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) WKMoviePlayerView *moviePlayerView;
@property (strong, nonatomic) UIImageView *overlayImageView;
@property (strong, nonatomic) WKVideoEditor *videoEditor;
@property (nonatomic) WKShareViewControllerMode mode;
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
    
    // Setup the social media button
    int numberOfNetworksEnabled = 0;
    for (NSDictionary *networkDict in [WKUser currentUser].socialNetworks) {
        NSString *key = networkDict.allKeys.lastObject;
        BOOL enabled = [[networkDict objectForKey:key] boolValue];
        if (enabled) {
            numberOfNetworksEnabled += 1;
        }
    }
    [self.socialMediaButton setTitle:[NSString stringWithFormat:@"%@ %i %@", NSLocalizedString(@"Sharing to", @""), numberOfNetworksEnabled, NSLocalizedString(@"social networks", @"")] forState:UIControlStateNormal];
    
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

#pragma mark - Set Share Mode

- (void)setMode:(WKShareViewControllerMode)mode {
    if (_mode != mode) {
        _mode = mode;
        
        [self updateUI];
    }
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGSize size = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.scrollView scrollRectToVisible:CGRectMake(0.0f, self.scrollView.contentSize.height - self.view.frame.size.height, self.scrollView.frame.size.width, self.view.frame.size.height) animated:YES];
    [UIView animateWithDuration:animationDuration delay:0.0f options:animationCurve animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0.0f, -size.height);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0f options:animationCurve animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - Update UI

- (void)updateUI {
    
    CGFloat animationDuration = 0.3f;
    
    switch (self.mode) {
        case WKShareViewControllerModeShare: {
            [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                
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
                
                NSMutableAttributedString *shareButtonAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Share your wink", @"").uppercaseString];
                [shareButtonAttrString addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                [shareButtonAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                [self.shareButton setAttributedTitle:shareButtonAttrString forState:UIControlStateNormal];
                
                self.shareButton.userInteractionEnabled = YES;
                
            } completion:nil];
        }
            break;
            
        case WKShareViewControllerModeSharing: {
            [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.backButton.transform = CGAffineTransformMakeTranslation(-self.backButton.center.x - roundf(self.backButton.frame.size.width/2.0f), 0.0f);
                self.backButton.alpha = 0.0f;
                self.placeholderTextView.backgroundColor = [UIColor clearColor];
                self.placeholderTextView.userInteractionEnabled = NO;
                self.placeholderTextView.hidden = !(self.placeholderTextView.text.length > 0);
                self.socialMediaContainerView.transform = CGAffineTransformMakeTranslation(0.0f, self.socialMediaContainerView.frame.size.height);
                self.socialMediaContainerView.alpha = 0.0f;
                
                self.shareButton.layer.borderColor = [UIColor purpleColorWithAlpha:1.0f].CGColor;
                self.shareButton.layer.borderWidth = 2.0f;
                self.shareButton.backgroundColor = [UIColor clearColor];
                
                NSMutableAttributedString *shareButtonAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Sharing...", @"").uppercaseString];
                [shareButtonAttrString addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                [shareButtonAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColorWithAlpha:1.0f] range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                [self.shareButton setAttributedTitle:shareButtonAttrString forState:UIControlStateNormal];
                
                self.shareButton.userInteractionEnabled = NO;
                
            } completion:nil];
        }
            break;
            
        case WKShareViewControllerModeShared: {
            [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.backButton.transform = CGAffineTransformMakeTranslation(-self.backButton.center.x - roundf(self.backButton.frame.size.width/2.0f), 0.0f);
                self.backButton.alpha = 0.0f;
                self.placeholderTextView.backgroundColor = [UIColor clearColor];
                self.placeholderTextView.userInteractionEnabled = NO;
                self.placeholderTextView.hidden = !(self.placeholderTextView.text.length > 0);
                self.socialMediaContainerView.transform = CGAffineTransformMakeTranslation(0.0f, self.socialMediaContainerView.frame.size.height);
                self.socialMediaContainerView.alpha = 0.0f;
                
                self.shareButton.layer.borderColor = [UIColor clearColor].CGColor;
                self.shareButton.layer.borderWidth = 0.0f;
                self.shareButton.backgroundColor = [UIColor greenColorWithAlpha:1.0f];
                
                NSMutableAttributedString *shareButtonAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"D-D-DONE!", @"").uppercaseString];
                [shareButtonAttrString addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                [shareButtonAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[shareButtonAttrString.string rangeOfString:shareButtonAttrString.string]];
                [self.shareButton setAttributedTitle:shareButtonAttrString forState:UIControlStateNormal];
                
                self.shareButton.userInteractionEnabled = YES;
                
            } completion:nil];
        }
            break;
            
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
        
        UIImageWriteToSavedPhotosAlbum(snapshot, nil, nil, nil);
        
        CWStatusBarNotification *notification = [[CWStatusBarNotification alloc] init];
        [notification displayNotificationWithMessage:NSLocalizedString(@"Saved to your camera roll!", @"") .uppercaseString forDuration:2.0f];
    }
    else if (self.mediaURL) {
        
        CWStatusBarNotification *notification = [[CWStatusBarNotification alloc] init];
        [notification displayNotificationWithMessage:NSLocalizedString(@"Saving to camera roll...", @"").uppercaseString completion:nil];
        
        AVAsset *asset = [AVAsset assetWithURL:self.mediaURL];
        self.videoEditor = [[WKVideoEditor alloc] init];
        [self.videoEditor exportVideo:asset overlay:self.overlayImage completed:^(BOOL success) {
            NSString *title = @"";
            if (success) {
                title = NSLocalizedString(@"Saved to your camera roll!", @"").uppercaseString;
            }
            else {
                title = NSLocalizedString(@"Error saving the video to your camera roll", @"").uppercaseString;
            }
            
            notification.notificationLabel.text = title;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [notification dismissNotification];
            });
        }];
    }
}

#pragma mark - Post

- (void)post {
    [self.placeholderTextView resignFirstResponder];
    
    [self savePostToCameraRoll];
    
    if (self.image) {
        NSString *text = self.placeholderTextView.text;
        UIImage *image = self.image;
        UIImage *modifiedImage = self.modifiedImage;
        UIImage *overlayImage = self.overlayImage;
        
        self.mode = WKShareViewControllerModeSharing;
        
        [WKWinkConnect winkConnectPostImage:image modifiedImage:modifiedImage overlayImage:overlayImage text:text accessToken:[WKUser currentUser].accessToken success:^(id response) {
            NSLog(@"Success! %@", response);
            
            self.mode = WKShareViewControllerModeShared;
            
        } failure:^(NSError *error, id response) {
            NSLog(@"Failed to post image: %@", error.description);
            
            self.mode = WKShareViewControllerModeShare;
            
            [UIAlertView showWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"There was an error posting your image. Please try again.", @"") cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil tapBlock:nil];
        }];
    }
    else if (self.mediaURL) {
        NSString *text = self.placeholderTextView.text;
        NSURL *mediaURL = self.mediaURL;
        UIImage *overlayImage = self.overlayImage;
        
        self.mode = WKShareViewControllerModeSharing;
        
        [WKWinkConnect winkConnectPostVideo:mediaURL overlayImage:overlayImage text:text accessToken:[WKUser currentUser].accessToken success:^(id response) {
            NSLog(@"Success! %@", response);
            
            self.mode = WKShareViewControllerModeShared;
            
        } failure:^(NSError *error, id response) {
            NSLog(@"Failed to post video: %@", error.description);
            
            self.mode = WKShareViewControllerModeShare;
            
            [UIAlertView showWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"There was an error posting your video. Please try again.", @"") cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil tapBlock:nil];
        }];
    }
}

#pragma mark - Button Actions

- (IBAction)shareButtonTouched:(id)sender {
    if (self.mode == WKShareViewControllerModeShare) {
        [self post];
    }
    else if (self.mode == WKShareViewControllerModeShared) {
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
