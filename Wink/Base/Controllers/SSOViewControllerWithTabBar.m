//
//  SSOViewControllerWithTabBar.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOViewControllerWithTabBar.h"
#import "SSOFanPageViewController.h"
#import "WKSettingsViewController.h"
#import "SSOProfileViewController.h"
#import "SSOFanPageViewController.h"
#import "SSOProfileViewController.h"

#import <Masonry.h>

NSInteger const kTabBarHeight = 40;
CGFloat const kTabBarButtonOffset = 5.0f;
CGFloat const kTabBarOpacity = 0.90;

@interface SSOViewControllerWithTabBar ()

@property(strong, nonatomic) UIView *customTabBar;

@end

@implementation SSOViewControllerWithTabBar

#pragma mark - View lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setInitalViewControllers];
    [self setTabBar];
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
    SSOProfileViewController *profileVC = [SSOProfileViewController new];
    //The initial view controller of the storyboard is the navigation view controller
    UINavigationController *cameraNavigationController = [[UIStoryboard cameraStoryboard] instantiateInitialViewController];
    [self setViewControllers:@[cameraNavigationController, fanPageVC, profileVC]];
}

/**
 *  Initialize the tab bar UI
 */
- (void)setTabBar {
    [self.tabBar setHidden:YES];

    self.customTabBar = [UIView new];
    [self.customTabBar setAlpha:kTabBarOpacity];
    //@FIXME
    [self.customTabBar setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.customTabBar];
    [self.customTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.and.right.and.bottom.equalTo(self.view);
      make.height.equalTo([NSNumber numberWithInt:kTabBarHeight]);
    }];

    // Create the buttons
    UIButton *homeButton = [UIButton new];
    [homeButton setImage:[UIImage imageNamed:@"tab_bar_home_icon"] forState:UIControlStateNormal];
    [homeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [homeButton addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBar addSubview:homeButton];

    UIButton *cameraButton = [UIButton new];
    [cameraButton setImage:[UIImage imageNamed:@"tab_bar_camera_icon"] forState:UIControlStateNormal];
    [cameraButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBar addSubview:cameraButton];

    UIButton *profileButton = [UIButton new];
    [profileButton setImage:[UIImage imageNamed:@"tab_bar_profile_icon"] forState:UIControlStateNormal];
    [profileButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [profileButton addTarget:self action:@selector(profileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBar addSubview:profileButton];

    // Set constraints for the button
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.customTabBar);
      make.top.equalTo(self.customTabBar).with.offset(kTabBarButtonOffset);
      make.bottom.equalTo(self.customTabBar).with.offset(-kTabBarButtonOffset);
      make.width.equalTo([NSNumber numberWithFloat:kScreenSize.width / 3]);
    }];

    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.customTabBar).with.offset(kTabBarButtonOffset);
      make.bottom.equalTo(self.customTabBar).with.offset(-kTabBarButtonOffset);
      make.right.equalTo(cameraButton.mas_left);
      make.width.equalTo(cameraButton);

    }];

    [profileButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.customTabBar).with.offset(kTabBarButtonOffset);
      make.bottom.equalTo(self.customTabBar).with.offset(-kTabBarButtonOffset);
      make.left.equalTo(cameraButton.mas_right);
      make.width.equalTo(cameraButton);

    }];
}

#pragma mark - Action

/**
 *  When the home button is pressed, switch the VC
 *
 *  @param sender the button
 */
- (void)homeButtonPressed:(id)sender {
//    NSAssert(![self isBeingPresented], @"VC has to be presented");
    // Only present if the VC is not of Fanpage kind
//    if (![self isKindOfClass:[SSOFanPageViewController class]]) {
        // Simply switch the current VC
        [self setSelectedIndex:1];
//    }
//        UIViewController *presentingVC = [self presentingViewController];
//        [self dismissViewControllerAnimated:NO
//                                 completion:^{
//                                   [presentingVC presentViewController:[SSOFanPageViewController new]
//                                                              animated:NO
//                                                            completion:^{
//
//                                                            }];
//                                 }];
//    }
}

/**
 *  When the camera button is pressed, simply dismiss the view
 *
 *  @param sender the button
 */
- (void)cameraButtonPressed:(id)sender {
//    NSAssert(![self isBeingPresented], @"VC has to be presented");
//    [self dismissViewControllerAnimated:YES
//                             completion:^{
//
//                             }];
    [self setSelectedIndex:0];
}

/**
 *  When the profile button is pressed, simply switch the view
 *
 *  @param sender the button
 */
- (void)profileButtonPressed:(id)sender {
//    NSAssert(![self isBeingPresented], @"VC has to be presented");
    // Only present if the VC is not of Settings kind
//    if (![self isKindOfClass:[WKSettingsViewController class]]) {
        // Simply switch the current VC
        [self setSelectedIndex:2];
//        UIViewController *presentingVC = [self presentingViewController];
//        [self dismissViewControllerAnimated:NO
//                                 completion:^{
//                                   [presentingVC presentViewController:[SSOProfileViewController new] animated:NO completion:nil];
                                   //                                   [presentingVC presentViewController:[WKSettingsViewController new]
                                   //                                                              animated:NO
                                   //                                                            completion:^{
                                   //
                                   //                                                            }];
//                                 }];
//    }
}

@end
