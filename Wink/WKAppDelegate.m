//
//  WKAppDelegate.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKAppDelegate.h"
#import "WKNavigationController.h"
#import "WKLoginViewController.h"
#import "WKCameraViewController.h"
#import "WKUser.h"
#import "WKWinkConnect.h"
#import "GAI.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>

@implementation WKAppDelegate

#pragma mark - App Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for login/logout notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserChanged) name:kCurrentUserStatusChanged object:nil];

    // Register for API authorization denied notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationDenied) name:kWinkConnectAuthorizationDenied object:nil];

    // Setup crashlytics
    [Fabric with:@[ CrashlyticsKit, TwitterKit ]];

    // Setup Google Analytics
    /*
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54518623-1"];
     */
    // Setup the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Setup state
    [self setupAnimated:NO];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background,
    // optionally refresh the user interface.

    // Update current user info
    [WKUser updateCurrentUserInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Setup State

- (void)setupAnimated:(BOOL)animated {

    // Logged In
    // if ([WKUser currentUser]) {
    WKCameraViewController *cameraController = [[WKCameraViewController alloc] initWithNibName:@"WKCameraViewController" bundle:nil];
    WKNavigationController *navController = [[WKNavigationController alloc] initWithRootViewController:cameraController];
    self.window.rootViewController = navController;
    /*}
    // Logged Out
    else {
        WKLoginViewController *loginController = [[WKLoginViewController alloc] initWithNibName:@"WKLoginViewController" bundle:nil];
        WKNavigationController *navController = [[WKNavigationController alloc] initWithRootViewController:loginController];
        navController.navigationBarHidden = YES;
        self.window.rootViewController = navController;
    }
     */
}

#pragma mark - Current User Changed

- (void)currentUserChanged {
    [self setupAnimated:YES];
}

#pragma mark - Authorization Denied

- (void)authorizationDenied {
    [WKUser logoutCurrentUser];
}

@end
