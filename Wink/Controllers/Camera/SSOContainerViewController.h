//
//  SSOContainerViewController.h
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOCameraContainerViewController.h"

@interface SSOContainerViewController : UIViewController

/**
 *  View controllers available inside the container
 */
@property(strong, nonatomic) SSOCameraContainerViewController *cameraContainerVC;

/**
 *  Set the initial container view controller
 *
 *  @param viewControllerType
 */
- (void)setInitialViewController;

@end
