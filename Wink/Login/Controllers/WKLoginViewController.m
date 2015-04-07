//
//  WKLoginViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKLoginViewController.h"
#import "WKWinkConnect.h"
#import "WKUser.h"
#import <TwitterKit/TwitterKit.h>
#import "WKCameraViewController.h"
#import "WKNavigationController.h"
#import "WKAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SSOGooglePlusHelper.h"
#import "SSOSocialNetworkAPI.h"

@interface WKLoginViewController ()

// UI
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;
@property(weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property(weak, nonatomic) IBOutlet UIButton *registerButton;

@property(strong, nonatomic) SSOGooglePlusHelper *googlePlusHelper;

@end

@implementation WKLoginViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSocialNetworks];
    [self setUI];
    [self addObservers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupViewForAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Utilities

/**
 *  Add observers to the VC
 */
- (void)addObservers {
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setSocialNetworks {

    self.googlePlusHelper = [SSOGooglePlusHelper sharedInstance];

    TWTRLogInButton *logInButton = [self setTwitterLoginButton];

    GPPSignInButton *googleLogInButton = [self googlePlusButton];

    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];

    googleLogInButton.frame = CGRectMake(logInButton.frame.origin.x, self.view.center.y - logInButton.frame.size.height - 20, logInButton.frame.size.width,
                                         logInButton.frame.size.height);

    [self.view addSubview:googleLogInButton];

    // Set the facebook login frame
    self.facebookLoginButton.frame = CGRectMake(logInButton.frame.origin.x, self.view.center.y + logInButton.frame.size.height + 20,
                                                logInButton.frame.size.width, logInButton.frame.size.height);
}

/**
 *  Set the UI of the view on load
 */
- (void)setUI {

    // Setup the background image
    if (self.isPhone) {
        if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
            self.imageView.image = [UIImage imageNamed:@"loginBackground_568h.png"];
        } else {
            self.imageView.image = [UIImage imageNamed:@"loginBackground.png"];
        }
    } else {
        self.imageView.image = [UIImage imageNamed:@"loginBackground_iPad.png"];
    }

    // Setup the textfields & button
    UIView *marginView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, self.usernameTextfield.frame.size.height)];
    self.usernameTextfield.leftView = marginView1;
    self.usernameTextfield.leftViewMode = UITextFieldViewModeAlways;

    UIView *marginView2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, self.passwordTextfield.frame.size.height)];
    self.passwordTextfield.leftView = marginView2;
    self.passwordTextfield.leftViewMode = UITextFieldViewModeAlways;

    self.loginButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.loginButton.titleLabel.minimumScaleFactor = 0.5f;
    [self.loginButton setTitle:NSLocalizedString(@"Sign In", @"").uppercaseString forState:UIControlStateNormal];
}

/**
 *  Set UI to display animations when the view appears
 */
- (void)setupViewForAnimation {

    // Setup textfields and button for animation
    self.usernameTextfield.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.usernameTextfield.alpha = 0.0f;
    self.passwordTextfield.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.passwordTextfield.alpha = 0.0f;
    self.loginButton.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.loginButton.alpha = 0.0f;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      CGFloat duration = 0.5f;
      CGFloat delay = 0.2f;

      CGFloat damping = 0.55f;
      CGFloat velocity = 0.75f;

      [UIView animateWithDuration:duration
                            delay:(delay * 0.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         self.facebookLoginButton.transform = CGAffineTransformIdentity;
                         self.facebookLoginButton.alpha = 1.0f;
                       }
                       completion:nil];

      [UIView animateWithDuration:duration
                            delay:(delay * 1.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         self.usernameTextfield.transform = CGAffineTransformIdentity;
                         self.usernameTextfield.alpha = 1.0f;
                       }
                       completion:nil];

      [UIView animateWithDuration:duration
                            delay:(delay * 2.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         self.passwordTextfield.transform = CGAffineTransformIdentity;
                         self.passwordTextfield.alpha = 1.0f;
                       }
                       completion:nil];

      [UIView animateWithDuration:duration
                            delay:(delay * 3.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         self.loginButton.transform = CGAffineTransformIdentity;
                         self.loginButton.alpha = 1.0f;
                       }
                       completion:nil];
    });
}

/**
 *  Set the twitter's login button
 *
 *  @return the button
 */
- (TWTRLogInButton *)setTwitterLoginButton {

    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
      // play with Twitter session
      if (session) {
          NSLog(@"signed in as %@", [session userName]);
          // Save the account value
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTwitterSwitchValue];
          [[NSUserDefaults standardUserDefaults] synchronize];

          // Push to camera view
          [SSOSocialNetworkAPI pushToCameraViewController];

      } else {
          NSLog(@"error: %@", [error localizedDescription]);
          // Save the account value
          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kTwitterSwitchValue];
          [[NSUserDefaults standardUserDefaults] synchronize];
      }
    }];

    return logInButton;
}

/**
 *  Return a Google + button ( Added it in order to customize if necessary and keep it consistent with the twitter button )
 *
 *  @return the Google + button
 */
- (GPPSignInButton *)googlePlusButton {

    GPPSignInButton *button = [[GPPSignInButton alloc] init];

    return button;
}

#pragma mark - View utilities

#pragma mark - Keyboard Methods

/**
 *  Listen to the UIKeyboardWillShow notifcation and move the view up
 *
 *  @param notification UIKeyboardWillShow
 */
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

/**
 *  Listen to the UIKeyboardWillHide notifcation and move the view down
 *
 *  @param notification UIKeyboardWillHide
 */
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

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    // Dismiss the text view
    [self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
}

#pragma mark - Textfield Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextfield) {
        [self.passwordTextfield becomeFirstResponder];
    } else {
        [self loginButtonTouched:self.loginButton];
    }
    return YES;
}

#pragma mark - Button Actions

/**
 *  Send the credentials to the backend for login
 *
 *  @param sender the login button
 */
- (IBAction)loginButtonTouched:(id)sender {
    [self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];

    if (self.usernameTextfield.text.length > 0 && self.passwordTextfield.text.length > 0) {

        // Show an alertView with no buttons, will change this later with SVProgress or something else
        // TODO: change this with SVProgress or something else
        UIAlertView *alert =
            [UIAlertView showWithTitle:NSLocalizedString(@"Signing In...", @"") message:nil cancelButtonTitle:nil otherButtonTitles:nil tapBlock:nil];

        [WKWinkConnect winkConnectLoginWithUsername:self.usernameTextfield.text
            password:self.passwordTextfield.text
            meta:@"meta"
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // Dismiss the alert
              [alert dismissWithClickedButtonIndex:0 animated:YES];
              NSLog(@"JSON: %@", responseObject);

              // Save the account value
              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEmailLoggedValue];
              [[NSUserDefaults standardUserDefaults] synchronize];

              // Push the camera view controller
              [SSOSocialNetworkAPI pushToCameraViewController];

            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              // Dismiss the alert
              [alert dismissWithClickedButtonIndex:0 animated:YES];
              [UIAlertView showWithTitle:NSLocalizedString(@"Error", @"")
                                 message:NSLocalizedString(@"Please verify your username and password are correct and try again!", @"")
                       cancelButtonTitle:NSLocalizedString(@"ok", @"")
                       otherButtonTitles:nil
                                tapBlock:nil];
            }];
    } else {
        [UIAlertView showWithTitle:NSLocalizedString(@"Missing Information", @"")
                           message:NSLocalizedString(@"Both username and password are required to login", @"")
                 cancelButtonTitle:NSLocalizedString(@"ok", @"")
                 otherButtonTitles:nil
                          tapBlock:nil];
    }
}

/**
 *  Send to the backend the informations the user entered to register
 *
 *  @param sender the register button
 */
- (IBAction)registerWithEmailButtonTouched:(id)sender {

    UIAlertView *alert =
        [UIAlertView showWithTitle:NSLocalizedString(@"Signing In...", @"") message:nil cancelButtonTitle:nil otherButtonTitles:nil tapBlock:nil];

    [WKWinkConnect winkConnectRegisterWithUsername:self.usernameTextfield.text
        password:self.passwordTextfield.text
        meta:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {

          [alert dismissWithClickedButtonIndex:0 animated:YES];

          // Save the account value
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEmailLoggedValue];
          [[NSUserDefaults standardUserDefaults] synchronize];

          UIAlertView *alert =
              [UIAlertView showWithTitle:NSLocalizedString(@"Registered", @"") message:nil cancelButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
          // Push the camera view controller

          [alert dismissWithClickedButtonIndex:0 animated:YES];

          [SSOSocialNetworkAPI pushToCameraViewController];

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {

          [alert dismissWithClickedButtonIndex:0 animated:YES];

        }];
}

// TODO: Won't be there anymore I guess
- (IBAction)loginWithFacebookButtonTapped:(id)sender {
}

@end
