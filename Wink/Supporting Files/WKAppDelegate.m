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
#import "SSOSocialNetworkAPI.h"
#import "SSOViewControllerWithTabBar.h"
#import <SEGAnalytics.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import <PonyDebugger/PonyDebugger.h>
#import <GooglePlus/GooglePlus.h>
#import <IQKeyboardManager.h>
#import "WKShareViewController.h"
#import "SSSessionManager.h"
#import "OnboardingContentViewController.h"
#import "SSOOnboarding.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation WKAppDelegate

#pragma mark - App Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize the Analytics instance with the
    // write key for pblondin/cafemtl
    [SEGAnalytics setupWithConfiguration:[SEGAnalyticsConfiguration configurationWithWriteKey:kSegmentIoKey]];
    
    // Enable analytics
    [[SEGAnalytics sharedAnalytics] enable];
    [[SEGAnalytics sharedAnalytics] track:@"App Opened"];
    
    
    //     Setup crashlytics
    [Fabric with:@[ CrashlyticsKit, TwitterKit]];
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
    
    
#ifdef DEBUG
    // Initialize PonyDebugger
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://192.168.1.143:9000/device"]];
    
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    [debugger enableCoreDataDebugging];
#endif
    
    // Set permissions for Facebook
    [[SSOSocialNetworkAPI sharedInstance] setFacebookPermissions:@[ @"publish_actions" ]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasOnboardedKey"];
    //    if (userHasOnboarded==YES) {
    //        [self setupNormalRootViewController];
    //    }
    //    else {
    self.window.rootViewController = [self showOnboarding];
    //    }
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[WKShareViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WKShareViewController class]];
    
    [self.window makeKeyAndVisible];
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void) setupNormalRootViewController {
    self.window.rootViewController = [SSOViewControllerWithTabBar new];
}

- (void)handleOnboardingCompletion {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasOnboardedKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setupNormalRootViewController];
}

- (SSOOnboarding*) showOnboarding {
    
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page1.title", @"WELCOME") body:NSLocalizedString(@"onboarding.page1.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:[UIImage imageNamed:@"1"] buttonText:@"" action:^{}];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page2.title", @"INTERACT") body:NSLocalizedString(@"onboarding.page2.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:[UIImage imageNamed:@"2"] buttonText:@"" action:^{}];
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page3.title", @"CAPTURE") body:NSLocalizedString(@"onboarding.page3.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:[UIImage imageNamed:@"3"] buttonText:@"" action:^{}];
    
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page4.title", @"PERSONALIZE") body:NSLocalizedString(@"onboarding.page4.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:[UIImage imageNamed:@"4"] buttonText:@"Got it!" action:^{
        [self handleOnboardingCompletion];
    }];
    
    // Image
    UIImage *bgImage = [UIImage imageNamed:@"bg"];
    
    SSOOnboarding *onboardingVC = [SSOOnboarding onboardWithBackgroundImage:[self imageWithImage:bgImage convertToSize:[UIScreen mainScreen].bounds.size] contents:@[firstPage, secondPage, thirdPage, fourthPage]];

    onboardingVC.fontName = @"Avenir-Light";
    onboardingVC.titleFontSize = 20;
    onboardingVC.bodyFontSize = 14;

    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.swipingEnabled = YES;
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipButton.alpha = 0.0f;
    onboardingVC.pageControl.alpha = 0.0f;
    
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
    };
    
    [self stylePage:firstPage];
    [self stylePage:secondPage];
    [self stylePage:thirdPage];
    [self stylePage:fourthPage];
    
    firstPage.viewWillAppearBlock = ^{
        CGRect framePager = onboardingVC.pageControl.frame;
        framePager.origin.y = [UIScreen mainScreen].bounds.size.height - framePager.size.height - 10.0f;
        onboardingVC.pageControl.frame = framePager;
        
        CGRect frame = onboardingVC.skipButton.frame;
        frame.origin.x = 0.0f;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - 8.0f;
        onboardingVC.skipButton.frame = frame;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35f];
        onboardingVC.skipButton.alpha = 1.0f;
        onboardingVC.pageControl.alpha = 1.0f;
        [UIView commitAnimations];
        
    };
    
    thirdPage.viewWillAppearBlock = ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35f];
        onboardingVC.skipButton.alpha = 1.0f;
        onboardingVC.pageControl.alpha = 1.0f;
        [UIView commitAnimations];
    };
    
    fourthPage.viewWillAppearBlock = ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35f];
        onboardingVC.skipButton.alpha = 0.0f;
        onboardingVC.pageControl.alpha = 0.0f;
        [UIView commitAnimations];
    };
    
    return onboardingVC;
}

- (void) stylePage: (OnboardingContentViewController *)page {
    page.topPadding = 0.0f;
    page.underIconPadding = 24.0f;
    page.underTitlePadding = 18.0f;
    page.bottomPadding = -30.0f;

    
    page.accessibilityLabel = @"OnboardingPage";
    
    page.viewDidAppearBlock = ^{
        [[SEGAnalytics sharedAnalytics] track:@"Slide Swiped"];
    };
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background,
    // optionally refresh the user interface.
    
    //[FBAppCall handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:kSchemeFacebook])
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    //        return [FBSession.activeSession handleOpenURL:url];
    
    if ([[url scheme] isEqualToString:kSchemeGooglePlus])
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return NO;
    //  return [FBSession.activeSession handleOpenURL:url];
}

@end
