//
//  SSOContainerViewController.h
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOPhotoContainerViewController.h"
#import "SSOVideoContainerViewController.h"

@interface SSOContainerViewController : UIViewController

/**
 *  View controllers available inside the container
 */
@property(strong, nonatomic) SSOPhotoContainerViewController *photoContainerVC;
@property(strong, nonatomic) SSOVideoContainerViewController *videoContainerVC;

typedef NS_ENUM(NSInteger, ContainerViewControllerType) {
    /**
     *  Photo Container
     */
    PhotoContainerCamera,
    /**
     *  Video Container
     */
    VideoContainerCamera
};

/**
 *  Set the initial container view controller
 *
 *  @param viewControllerType
 */
- (void)setInitialViewController:(ContainerViewControllerType)viewControllerType;

/**
 *  Swap view controller to type
 *
 *  @param type (Photo or Video)
 */
- (void)swapToViewControllerOfType:(ContainerViewControllerType)type;

@end
