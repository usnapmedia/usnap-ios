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
#import "SDiPhoneVersion.h"

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
    
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasOnboardedKey"];
    if (userHasOnboarded==YES) {

        [self setupNormalRootViewController];

    }
    else {
        self.window.rootViewController = [self showOnboarding];
    }
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[WKShareViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WKShareViewController class]];
    
    [self.window makeKeyAndVisible];

    // determine whether we've launched from a shortcut item or not
    UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if ([item.type isEqualToString:@"com.usnap.quickshoot"]) {
        NSLog(@"We've launched from shortcut item: %@", item.type);
        SSOViewControllerWithTabBar* VC = (SSOViewControllerWithTabBar*)self.window.rootViewController;
        [VC cameraButtonPressed:nil];
    }

    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if ([shortcutItem.type isEqualToString:@"com.usnap.quickshoot"]) {
        NSLog(@"We've launched from shortcut item: %@", shortcutItem.type);
        SSOViewControllerWithTabBar* VC = (SSOViewControllerWithTabBar*)self.window.rootViewController;
        [VC cameraButtonPressed:nil];
    }
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
    
    UIImage *image1 = [UIImage imageNamed:@"1"];
    UIImage *image2 = [UIImage imageNamed:@"2"];
    UIImage *image3 = [UIImage imageNamed:@"3"];
    UIImage *image4 = [UIImage imageNamed:@"4"];
    
    
    if ([SDiPhoneVersion deviceSize] == iPhone35inch) {
        image1 = [self imageWithImage:image1 convertToSize:CGSizeMake(image1.size.width-60.0f, image1.size.width-60.0f)];
        image2 = [self imageWithImage:image2 convertToSize:CGSizeMake(image2.size.width-60.0f, image2.size.width-60.0f)];
        image3 = [self imageWithImage:image3 convertToSize:CGSizeMake(image3.size.width-60.0f, image3.size.width-60.0f)];
        image4 = [self imageWithImage:image4 convertToSize:CGSizeMake(image4.size.width-60.0f, image4.size.width-60.0f)];
    } else if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        image1 = [self imageWithImage:image1 convertToSize:CGSizeMake(image1.size.width, image1.size.width)];
        image2 = [self imageWithImage:image2 convertToSize:CGSizeMake(image2.size.width, image2.size.width)];
        image3 = [self imageWithImage:image3 convertToSize:CGSizeMake(image3.size.width, image3.size.width)];
        image4 = [self imageWithImage:image4 convertToSize:CGSizeMake(image4.size.width, image4.size.width)];
    }
    
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page1.title", @"WELCOME") body:NSLocalizedString(@"onboarding.page1.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:image1 buttonText:@"" action:^{}];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page2.title", @"INTERACT") body:NSLocalizedString(@"onboarding.page2.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:image2 buttonText:@"" action:^{}];
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page3.title", @"CAPTURE") body:NSLocalizedString(@"onboarding.page3.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:image3 buttonText:@"" action:^{}];
    
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:NSLocalizedString(@"onboarding.page4.title", @"PERSONALIZE") body:NSLocalizedString(@"onboarding.page4.body",@"Bacon ipsum dolor amet hamburger filet mignon tenderloin shankle, meatloaf pork chop sirloin tail kevin. Kielbasa turducken drumstick ribeye. Pastrami tenderloin short loin pancetta ham, pork loin cupim drumstick porchetta.") image:image4 buttonText:@"Got it!" action:^{
        [self handleOnboardingCompletion];
    }];
    
    // Image
    UIImage *bgImage = [UIImage imageNamed:@"bg"];
    
    SSOOnboarding *onboardingVC = [SSOOnboarding onboardWithBackgroundImage:[self imageWithImage:bgImage convertToSize:[UIScreen mainScreen].bounds.size] contents:@[firstPage, secondPage, thirdPage, fourthPage]];

    onboardingVC.fontName = @"Avenir-Light";
    float skipButtonAdjustment = 0.0f;
    float pagerAdjustment = 0.0f;
    
    switch ([SDiPhoneVersion deviceSize]) {
        case iPhone35inch:
            onboardingVC.titleFontSize = 14;
            onboardingVC.bodyFontSize = 10;
            skipButtonAdjustment = 0.0f;
            pagerAdjustment = 2.0f;
            break;
        case iPhone4inch:
            onboardingVC.titleFontSize = 16;
            onboardingVC.bodyFontSize = 12;
            skipButtonAdjustment = 2.0f;
            pagerAdjustment = 4.0f;
            break;
        case iPhone47inch:
            onboardingVC.titleFontSize = 18;
            onboardingVC.bodyFontSize = 14;
            skipButtonAdjustment = 8.0f;
            pagerAdjustment = 10.0f;
            break;
        case iPhone55inch:
            onboardingVC.titleFontSize = 20;
            onboardingVC.bodyFontSize = 14;
            skipButtonAdjustment = 8.0f;
            pagerAdjustment = 10.0f;
            break;
        default:
            break;
    }
    
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
        framePager.origin.y = [UIScreen mainScreen].bounds.size.height - framePager.size.height - pagerAdjustment;
        onboardingVC.pageControl.frame = framePager;
        
        CGRect frame = onboardingVC.skipButton.frame;
        frame.origin.x = 0.0f;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - skipButtonAdjustment;
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
    switch ([SDiPhoneVersion deviceSize]) {
        case iPhone35inch:
            page.topPadding = 4.0f;
            page.underIconPadding = 12.0f;
            page.underTitlePadding = 4.0f;
            page.bottomPadding = -40.0f;
            break;
        case iPhone4inch:
            page.topPadding = 4.0f;
            page.underIconPadding = 12.0f;
            page.underTitlePadding = 4.0f;
            page.bottomPadding = -36.0f;
            break;
        case iPhone47inch:
            page.topPadding = 0.0f;
            page.underIconPadding = 12.0f;
            page.underTitlePadding = 4.0f;
            page.bottomPadding = -34.0f;
            break;
        case iPhone55inch:
            page.topPadding = 0.0f;
            page.underIconPadding = 24.0f;
            page.underTitlePadding = 18.0f;
            page.bottomPadding = -30.0f;
            break;
        default:
            break;
    }
    
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
