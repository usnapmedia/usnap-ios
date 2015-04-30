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
#import "SSOViewControllerWithLiveFeed.h"

#import <Masonry.h>

NSInteger const kTabBarHeight = 40;
CGFloat const kTabBarButtonOffset = 5.0f;
CGFloat const kTabBarOpacity = 0.90;

@interface SSOViewControllerWithTabBar () <LiveFeedViewControllerDelegate>

@property(strong, nonatomic) UIView *customTabBar;

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

    self.viewControllers = @[ fanPageVC, profileVC ];
    // The initial view controller of the storyboard is the navigation view controller
    //    [self setViewControllers:@[ fanPageVC, profileVC ]];
}

- (void)startFirstViewController
{
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
    //    [self.tabBar setHidden:NO];
    //    CGRect tabBarFrame = self.tabBar.frame;
    //    CGRect newFrame = CGRectMake(tabBarFrame.origin.x, self.tabBar.frame.origin.y + (tabBarFrame.size.height - kTabBarHeight),
    //    self.tabBar.frame.size.width, kTabBarHeight);
    //    [self.tabBar setFrame:newFrame];

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

- (CGRect)containerViewFrame {
    return CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - kTabBarHeight);
}

- (void)switchCurrentViewControllerToNewViewController:(UIViewController *)newVC {
    UIViewController *oldVC = [self.viewControllers objectAtIndex:self.selectedIndex];
    [oldVC willMoveToParentViewController:nil]; // 1
    [self addChildViewController:newVC];
    newVC.view.frame = [self containerViewFrame];
    [self transitionFromViewController: oldVC toViewController: newVC   // 3
                              duration: 0.25 options:0
                            animations:^{
                                newVC.view.frame = oldVC.view.frame;                       // 4
//                                oldVC.view.frame = endFrame;
                            }
                            completion:^(BOOL finished) {
                                [oldVC removeFromParentViewController];                   // 5
                                [newVC didMoveToParentViewController:self];
                            }];
//    CGRect endFrame = [self containerViewFrame]; //If I need a transition
//    [oldVC removeFromParentViewController]; // 5
//    [newVC didMoveToParentViewController:self];
}

#pragma mark - Action

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
}

/**
 *  When the camera button is pressed, simply dismiss the view
 *
 *  @param sender the button
 */
- (void)cameraButtonPressed:(id)sender {
    UINavigationController *cameraNavigationController = [[UIStoryboard cameraStoryboard] instantiateInitialViewController];
    SSOViewControllerWithLiveFeed *liveFeed = [cameraNavigationController.viewControllers firstObject];
    liveFeed.displayFanPageDelegate = self;
    [self presentViewController:cameraNavigationController animated:YES completion:nil];
}
/**
 *  When the profile button is pressed, simply switch the view
 *
 *  @param sender the button
 */
- (void)profileButtonPressed:(id)sender {
    if (self.selectedIndex != 1) {
        [self switchCurrentViewControllerToNewViewController:[self.viewControllers lastObject]];
        self.selectedIndex = 1;
    }
}

#pragma mark - LiveFeedViewControllerDelegate

- (void)userDidDismissCamera {
    if (self.selectedIndex != 0) {
        [self switchCurrentViewControllerToNewViewController:[self.viewControllers firstObject]];
        self.selectedIndex = 0;
    }
}

@end
