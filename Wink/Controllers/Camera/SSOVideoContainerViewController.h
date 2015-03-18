//
//  SSOVideoContainerViewController.h
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoRecordingDelegate.h"

@interface SSOVideoContainerViewController : UIImagePickerController

@property(nonatomic) CGFloat heightOfTopBlackBar;
@property(strong, nonatomic) id<VideoRecordingDelegate> videoDelegate;

/**
 *  Turn the rear camera off, i.e. turn the front facing camera on
 */
- (void)turnRearCameraOff;

/**
 *  Turn the rear camera on, i.e. turn the front facing camera on
 */
- (void)turnRearCameraOn;

@end
