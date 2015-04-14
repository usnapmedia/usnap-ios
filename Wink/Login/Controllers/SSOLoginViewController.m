//
//  SSOLoginViewController.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOLoginViewController.h"

#import "SSOSocialNetworkAPI.h"
#import "SSOLoginContainerView.h"
#import "SSORegisterContainerView.h"
#import <Masonry.h>
#import "SSOCustomSignInButton.h"
#import "WKWinkConnect.h"

@interface SSOLoginViewController ()
@property(weak, nonatomic) IBOutlet UIView *loginContainerView;
@property(weak, nonatomic) IBOutlet UIView *registerContainerView;
@property(strong, nonatomic) SSOLoginContainerView *loginView;
@property(strong, nonatomic) SSORegisterContainerView *registerView;
@property(weak, nonatomic) IBOutlet SSOCustomSignInButton *loginButton;
@property(weak, nonatomic) IBOutlet SSOCustomSignInButton *signUpButton;

@end

@implementation SSOLoginViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self setSocialNetworks];
    //  [self setUI];
    //   [self addObservers];

    [self setUI];

    self.loginView.delegate = self;
    self.registerView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self setupViewForAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Utilities

/**
 *  Set the UI for the VC
 */
- (void)setUI {

    self.loginView.backgroundColor = [UIColor clearColor];
    self.loginContainerView.backgroundColor = [UIColor clearColor];

    self.registerView.backgroundColor = [UIColor clearColor];
    self.registerContainerView.backgroundColor = [UIColor clearColor];
    self.registerContainerView.hidden = YES;

    self.loginButton.selected = YES;
    self.signUpButton.selected = NO;
}

/**
 *  Simple method to select/unselect the buttons
 */
- (void)switchSelectedButtons {
    self.signUpButton.selected = !self.signUpButton.selected;
    self.loginButton.selected = !self.loginButton.selected;
}

/**
 *  Simple method to hide/show the desired view
 */
- (void)switchHiddenContainers {

    self.loginContainerView.hidden = !self.loginContainerView.hidden;
    self.registerContainerView.hidden = !self.registerContainerView.hidden;
}

/**
 *  Add observers to the VC
 */
//- (void)addObservers {
//    // Register for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (SSOLoginContainerView *)loginView {
    if (!_loginView) {
        // Set the view for the helper
        _loginView = [NSBundle loadLoginContainerView];

        // Insert view
        [self.loginContainerView addSubview:_loginView];
        // Set the container inside the view to have constraints on the edges
        [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.loginContainerView);
        }];
    }

    return _loginView;
}

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (SSORegisterContainerView *)registerView {
    if (!_registerView) {
        // Set the view for the helper
        _registerView = [NSBundle loadRegisterContainerView];

        // Insert view
        [self.registerContainerView addSubview:_registerView];
        // Set the container inside the view to have constraints on the edges
        [_registerView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.registerContainerView);
        }];
    }

    return _registerView;
}

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
                       self.view.transform = CGAffineTransformMakeTranslation(0.0f, -size.height / 2);
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

#pragma mark - IBActions

- (IBAction)loginButtonPushed:(id)sender {
    // Check if the button is already selected and return if so.
    if (self.loginButton.selected) {
        return;
    }
    [self switchSelectedButtons];
    [self switchHiddenContainers];
}

- (IBAction)signUpButton:(id)sender {
    // Check if the button is already selected and return if so.
    if (self.signUpButton.selected) {
        return;
    }
    [self switchSelectedButtons];
    [self switchHiddenContainers];
}

#pragma mark - SSOLoginRegisterDelegate

- (void)didLoginWithInfo:(NSDictionary *)info {

    [WKWinkConnect winkConnectLoginWithUsername:[info valueForKey:@"email"]
        password:[info valueForKey:@"password"]
        meta:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Login success");

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Login failed");

        }];
}

- (void)didRegisterWithInfo:(NSDictionary *)info andMeta:(NSDictionary *)meta {

    [WKWinkConnect winkConnectRegisterWithUsername:[info valueForKey:@"email"]
        password:[info valueForKey:@"password"]
        meta:meta
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"Register success");

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Register failure");

        }];
}

@end
