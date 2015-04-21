//
//  WKAppDelegate.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKAppDelegate.h"
#import "WKWinkConnect.h"
#import "GAI.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import <PonyDebugger/PonyDebugger.h>

#import <GooglePlus/GooglePlus.h>

#import "SSOLoginViewController.h"
#import <IQKeyboardManager.h>
#import "WKShareViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation WKAppDelegate

#pragma mark - App Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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

    // Setup the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // [FBSession class];

    // Set permissions for Facebook
    [SSFacebookHelper sharedInstance].facebookPermissions = @[ @"publish_actions" ];

    [self setupRootViewController];

    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[WKShareViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WKShareViewController class]];

    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background,
    // optionally refresh the user interface.

    //[FBAppCall handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

        if ([[url scheme] isEqualToString:kSchemeFacebook])
            return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    //        return [FBSession.activeSession handleOpenURL:url];

    if ([[url scheme] isEqualToString:kSchemeGooglePlus])
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];

    return NO;
    //  return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Setup State

- (void)setupRootViewController {

    [self goCameraVC];
}

- (void)goCameraVC {
    UINavigationController *navController = [[UIStoryboard cameraStoryboard] instantiateViewControllerWithIdentifier:@"CAMERA_NAV_VC"];
    self.window.rootViewController = navController;
}

#pragma mark - Current User Changed

- (void)currentUserChanged {
    [self setupRootViewController];
}

@end
