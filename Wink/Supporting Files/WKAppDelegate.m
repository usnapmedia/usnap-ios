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
#import <PonyDebugger/PonyDebugger.h>

#import <GooglePlus/GooglePlus.h>

@implementation WKAppDelegate

#pragma mark - App Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for login/logout notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserChanged) name:kCurrentUserStatusChanged object:nil];

    // Register for API authorization denied notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationDenied) name:kWinkConnectAuthorizationDenied object:nil];

    [[Twitter sharedInstance] startWithConsumerKey:@"iig0OuJF0qucK8EXENTg4DPCF" consumerSecret:@"lrkVewgFN0Rnw1GGx6yMxWvhktQxfujJBRHGpkqw7Nd5XKcu7q"];
    //     Setup crashlytics
    [Fabric with:@[ CrashlyticsKit, TwitterKit ]];

#ifdef DEBUG
    // Initialize PonyDebugger
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://192.168.1.143:9000/device"]];

    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    [debugger enableCoreDataDebugging];
#endif

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

    [FBSession class];

    // Set permissions for Facebook
    [SSFacebookHelper sharedInstance].facebookPermissions = @[ @"publish_actions" ];

    //    // Do silent login if the user has logged on to Facebook before to validate the Facebook token, so they can post an image and video
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]) {
    //        [SSFacebookHelper silentLogin:^() {
    //          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFacebookSwitchValue];
    //          [[NSUserDefaults standardUserDefaults] synchronize];
    //          // Setup state
    //          [self setupAnimated:NO];

    //        } onFailure:^(NSError *error) {
    //          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFacebookSwitchValue];
    //          [[NSUserDefaults standardUserDefaults] synchronize];
    //          // Setup state
    //          [self setupAnimated:NO];

        }];
    } else {
        // Setup state
        [self setupRootViewController];
    }

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background,
    // optionally refresh the user interface.


    [FBAppCall handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([[url scheme] isEqualToString:kSchemeFacebook])
        return [FBSession.activeSession handleOpenURL:url];

    if ([[url scheme] isEqualToString:kSchemeGooglePlus])
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];

    return NO;
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Setup State

- (void)setupRootViewController {
   // if ([[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue] || [[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSwitchValue]) {
        [[NSUserDefaults standardUserDefaults] boolForKey:kEmailLoggedValue]) {
        WKCameraViewController *cameraController = [[WKCameraViewController alloc] initWithNibName:@"WKCameraViewController" bundle:nil];
        UINavigationController *navController = [[UIStoryboard cameraStoryboard] instantiateViewControllerWithIdentifier:@"CAMERA_NAV_VC"];
        self.window.rootViewController = navController;
  //  }
//    else {
//        WKLoginViewController *loginController = [[WKLoginViewController alloc] initWithNibName:@"WKLoginViewController" bundle:nil];
//        WKNavigationController *navController = [[WKNavigationController alloc] initWithRootViewController:loginController];
//        navController.navigationBarHidden = YES;
//        self.window.rootViewController = navController;
//    }
}

#pragma mark - Current User Changed

- (void)currentUserChanged {
    [self setupRootViewController];
}

#pragma mark - Authorization Denied

- (void)authorizationDenied {
    [WKUser logoutCurrentUser];
}

@end
