//
//  SSOViewControllerWithTabBar.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOViewControllerWithTabBar.h"
#import "SSOFanPageViewController.h"
#import "SSOProfileViewController.h"
#import "SSOFanPageViewController.h"
#import "SSOProfileViewController.h"
#import "SSOViewControllerWithLiveFeed.h"
#import "SSSessionManager.h"
#import "SSOLoginViewController.h"
#import <SEGAnalytics.h>
#import "SSOThemeHelper.h"

#import <Masonry.h>

@interface SSOViewControllerWithTabBar () <SSOLoginRegisterDelegate>

@property(strong, nonatomic) UIView *customTabBar;
@property(strong, nonatomic) UIButton *homeButton;
@property(strong, nonatomic) UIButton *profileButton;

@property(strong, nonatomic) NSArray *viewControllers;
@property(nonatomic) NSInteger selectedIndex;

@end

@implementation SSOViewControllerWithTabBar

#pragma mark - View lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setInitalViewControllers];
    [self setTabBar];
    [self startFirstViewController];
    [self setNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    [self setTabBar];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

/**
 *  Set the Initials View Controllers
 */
- (void)setInitalViewControllers {
    SSOFanPageViewController *fanPageVC = [SSOFanPageViewController new];
    UINavigationController *fanPageNC = [[UINavigationController alloc] initWithRootViewController:fanPageVC];
    [fanPageNC setNavigationBarHidden:YES];
    SSOProfileViewController *profileVC = [SSOProfileViewController new];
    UINavigationController *profilePageNC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [profilePageNC setNavigationBarHidden:YES];

    // Fan Page and Profile Page are on Navigation Controllers

    self.viewControllers = @[ fanPageNC, profilePageNC ];
}

/**
 *  Start the Fan Page View Controller
 */

- (void)startFirstViewController {
    UIViewController *containerVC = [self.viewControllers firstObject];
    // Add the child vc
    [self addChildViewController:containerVC];
    // Set the frame
    containerVC.view.frame = [self containerViewFrame];
    //
    [self.view addSubview:containerVC.view];
    // Call delegate
    [containerVC didMoveToParentViewController:self];
}

/**
 *  Initialize the tab bar UI
 */

- (void)setTabBar {
    if (self.customTabBar) {
        [self.customTabBar removeFromSuperview];
    }
    self.customTabBar = [UIView new];
    [self.customTabBar setBackgroundColor:[SSOThemeHelper tabBarColor]];
    [self.view addSubview:self.customTabBar];
    [self.customTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.and.right.and.bottom.equalTo(self.view);
      make.height.equalTo([NSNumber numberWithInt:kTabBarHeight]);
    }];

    // Create the buttons
    UIButton *homeButton = [UIButton new];
    [homeButton setBackgroundColor:[SSOThemeHelper tabBarSelectedColor]];
    [homeButton setImage:[UIImage imageNamed:@"ic_home"] forState:UIControlStateNormal];
    [homeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [homeButton setExclusiveTouch:YES];
    [homeButton addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBar addSubview:homeButton];
    self.homeButton = homeButton;

    UIButton *cameraButton = [UIButton new];
    [cameraButton setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
    [cameraButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBar addSubview:cameraButton];

    UIButton *profileButton = [UIButton new];
    [profileButton setImage:[UIImage imageNamed:@"ic_profile"] forState:UIControlStateNormal];
    [profileButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [profileButton addTarget:self action:@selector(profileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBar addSubview:profileButton];
    self.profileButton = profileButton;

    // Set constraints for the button
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.customTabBar);
      make.top.equalTo(self.customTabBar);
      make.bottom.equalTo(self.customTabBar);
      make.width.equalTo([NSNumber numberWithFloat:kScreenSize.width / 3]);
    }];

    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.customTabBar);
      make.bottom.equalTo(self.customTabBar);
      make.right.equalTo(cameraButton.mas_left);
      make.width.equalTo(cameraButton);
    }];

    [profileButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.customTabBar);
      make.bottom.equalTo(self.customTabBar);
      make.left.equalTo(cameraButton.mas_right);
      make.width.equalTo(cameraButton);
    }];
}

/**
 *  Return the size of the view less the size of the tab bar
 *
 *  @return The Size of the contet view
 */

- (CGRect)containerViewFrame {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    return CGRectMake(self.view.frame.origin.x, statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - kTabBarHeight - statusBarHeight);
}

/**
 *  Change the view that is visible
 *
 *  @param newVC the view to be displayed
 */

- (void)switchCurrentViewControllerToNewViewController:(UINavigationController *)newVC {
    UIViewController *oldVC = [self.viewControllers objectAtIndex:self.selectedIndex];
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
    newVC.view.frame = [self containerViewFrame];
    [newVC popToRootViewControllerAnimated:NO];

    // It does the transition from one view to the other

    [self transitionFromViewController:oldVC
        toViewController:newVC
        duration:0.25
        options:0
        animations:^{
          newVC.view.frame = oldVC.view.frame;
        }
        completion:^(BOOL finished) {
          [oldVC removeFromParentViewController];
          [newVC didMoveToParentViewController:self];
        }];
}

/**
 *  Set a notification to return to the fanpage VC when the user shares a content
 */

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToFanPageVC) name:kReturnToFanPageVC object:nil];
}

/**
 *  Return to Fan Page
 */

- (void)returnToFanPageVC {
    [self homeButtonPressed:self.homeButton];
    UINavigationController *navigationVC = [self.viewControllers firstObject];
    [navigationVC popToRootViewControllerAnimated:NO];
}

#pragma mark - Action

/**
 *  Loop through buttons in the tabBar. When we select one we want the others to be unselected
 *
 *  @param toButton the button
 */

- (void)unselectedButtonsTabBarWithSender:(UIButton *)toButton {

    for (UIButton *button in self.customTabBar.subviews) {
        [button setBackgroundColor:[SSOThemeHelper tabBarColor]];
    }
}

/**
 *  When the home button is pressed, switch the VC
 *
 *  @param sender the button
 */

- (void)homeButtonPressed:(id)sender {
    if (self.selectedIndex != 0) {
        [self switchCurrentViewControllerToNewViewController:[self.viewControllers firstObject]];
        self.selectedIndex = 0;
    }
    UIButton *button = (UIButton *)sender;
    [self unselectedButtonsTabBarWithSender:button];
    [button setBackgroundColor:[SSOThemeHelper tabBarSelectedColor]];
}

/**
 *  When the camera button is pressed, simply dismiss the view
 *
 *  @param sender the button
 */

- (void)cameraButtonPressed:(id)sender {
    UINavigationController *cameraNavigationController = [[UIStoryboard cameraStoryboard] instantiateInitialViewController];
    [[SEGAnalytics sharedAnalytics] track:@"Camera Started"];
    [self presentViewController:cameraNavigationController animated:YES completion:nil];
}

/**
 *  When the profile button is pressed, simply switch the view
 *
 *  @param sender the button
 */

- (void)profileButtonPressed:(id)sender {
    if ([[SSSessionManager sharedInstance] isUserLoggedIn]) {
        if (self.selectedIndex != 1) {
            [self switchCurrentViewControllerToNewViewController:[self.viewControllers lastObject]];
            self.selectedIndex = 1;
        }
        UIButton *button = (UIButton *)sender;
        [self unselectedButtonsTabBarWithSender:button];
        [button setBackgroundColor:[SSOThemeHelper tabBarSelectedColor]];
    } else {
        SSOLoginViewController *loginVC = [SSOLoginViewController new];
        loginVC.delegate = self;
        // Present VC
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - SSOLoginRegisterDelegate

/**
 *  Called when the loginVC is dismissed
 */
- (void)didFinishAuthProcess {
    [self profileButtonPressed:self.profileButton];
}

@end
