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

@interface WKLoginViewController ()

// UI
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;
@property(weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation WKLoginViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            // Save the account value
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTwitterSwitchValue];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // Push to camera view
            [self pushToCameraViewController];

        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            // Save the account value
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kTwitterSwitchValue];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];

    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];

    // Set the facebook login frame
    self.facebookLoginButton.frame = CGRectMake(logInButton.frame.origin.x, self.view.center.y + logInButton.frame.size.height + 20,
                                                logInButton.frame.size.width, logInButton.frame.size.height);

    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Setup textfields and button for animation
    self.usernameTextfield.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.usernameTextfield.alpha = 0.0f;
    self.passwordTextfield.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.passwordTextfield.alpha = 0.0f;
    self.loginButton.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.loginButton.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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
                             self.usernameTextfield.transform = CGAffineTransformIdentity;
                             self.usernameTextfield.alpha = 1.0f;
                         }
                         completion:nil];

        [UIView animateWithDuration:duration
                              delay:(delay * 1.0f)
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.passwordTextfield.transform = CGAffineTransformIdentity;
                             self.passwordTextfield.alpha = 1.0f;
                         }
                         completion:nil];

        [UIView animateWithDuration:duration
                              delay:(delay * 2.0f)
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

#pragma mark - View utilities

/**
 *  Pushes the user to the camera view controller
 */
- (void)pushToCameraViewController {
    // Send notification for the app delegate to handle the switch of controller
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentUserStatusChanged object:nil];
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGSize size = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

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

- (IBAction)loginButtonTouched:(id)sender {
    [self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];

    if (self.usernameTextfield.text.length > 0 && self.passwordTextfield.text.length > 0) {

        UIAlertView *alert =
            [UIAlertView showWithTitle:NSLocalizedString(@"Signing In...", @"") message:nil cancelButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
        
        
        [WKWinkConnect winkConnectLoginWithUsername:self.usernameTextfield.text password:self.passwordTextfield.text meta:@"meta" success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        [WKWinkConnect winkConnectLoginWithUsername:self.usernameTextfield.text password:self.passwordTextfield.text success:^(id response) {
            
        } failure:^(NSError *error, id response) {
            
        }];

        [WKWinkConnect winkConnectLoginWithUsername:self.usernameTextfield.text
            password:self.passwordTextfield.text
            success:^(id response) {

                [alert dismissWithClickedButtonIndex:0 animated:YES];

                NSDictionary *responseDict = (NSDictionary *)response;
                WKUser *user = [[WKUser alloc] initWithDictionary:responseDict];
                [WKUser loginUser:user];

            }
            failure:^(NSError *error, id response) {
                NSLog(@"%@", error.description);

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

- (IBAction)loginWithFacebookButtonTapped:(id)sender {

    [SSFacebookHelper login:^() {
        // Push to camera view
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFacebookSwitchValue];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // Push the camera view controller
        [self pushToCameraViewController];

    } onFailure:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFacebookSwitchValue];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [UIAlertView showWithTitle:NSLocalizedString(@"Error", @"")
                           message:NSLocalizedString(@"There was a problem connecting to Facebook. Please try again later.", @"")
                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                 otherButtonTitles:nil
                          tapBlock:nil];
    }];
}

@end
