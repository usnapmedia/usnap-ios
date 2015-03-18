//
//  SSOPhotoContainerViewController.h
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSOPhotoContainerViewController : UIViewController

@property(nonatomic) CGFloat heightOfTopBlackBar;

/**
 *  The camera's flash was turned on
 */
- (void)flashTurnedOn;

/**
 *  The camera's flash was turned off
 */
- (void)flashTurnedOff;

/**
 *  The camera's rear camera was activated
 */
- (void)rearCameraTurnedOn;

/**
 *  The camera's rear camera was disactivated
 */
- (void)rearCameraTurnedOff;

/**
 *  Take photo
 */
- (void)takePhoto;

@end
