//
//  SSOViewControllerWithLiveFeed.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOViewControllerWithLiveFeed.h"
#import "SSOFeedViewController.h"
#import <Masonry.h>
#import <SSOSimpleCollectionViewProvider.h>

#define kFeedContainerHeight 55

@interface SSOViewControllerWithLiveFeed () <SSOProviderDelegate>

@end

@implementation SSOViewControllerWithLiveFeed

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the view
    [self initializeFeedContainerView];
    [self initializeFeedController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

/**
 *  Initialize the container view
 */
- (void)initializeFeedContainerView {
    self.feedContainerView = [UIView new];
    [self.view addSubview:self.feedContainerView];
    [self.feedContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.and.left.and.right.equalTo(self.view);
      make.height.equalTo([NSNumber numberWithInt:kFeedContainerHeight]);
    }];
}

/**
 *  Initialize the feed view controller
 */
- (void)initializeFeedController {
    SSOFeedViewController *childVc = [SSOFeedViewController new];
    // Add the child vc
    [self addChildViewController:childVc];
    // Set the frame
    childVc.view.frame = self.feedContainerView.frame;
    //    // Add subview
    [self.feedContainerView addSubview:childVc.view];
    // Call delegate
    [childVc didMoveToParentViewController:self];

    //  Make the view delegate for the provider to access the on select event
    childVc.provider.delegate = self;
}

#pragma mark - SSOProviderDelegate

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //@TODO Present fan page
    [self presentViewController:[UIViewController new] animated:YES completion:nil];
}

@end
