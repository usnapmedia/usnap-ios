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

    // Set permissions for Facebook
    [SSFacebookHelper sharedInstance].facebookPermissions = @[ @"publish_actions" ];

    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[WKShareViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WKShareViewController class]];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background,
    // optionally refresh the user interface.

    //[FBAppCall handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

//    if ([[url scheme] isEqualToString:kSchemeFacebook])
//        return [FBSession.activeSession handleOpenURL:url];

    if ([[url scheme] isEqualToString:kSchemeGooglePlus])
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];

    return NO;
  //  return [FBSession.activeSession handleOpenURL:url];
}

@end
