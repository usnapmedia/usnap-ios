//
//  SSOVideoContainerViewController.h
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoRecordingDelegate.h"
#import <FastttCamera.h>

@interface SSOCameraContainerViewController : UIViewController

@property(nonatomic) CGFloat heightOfTopBlackBar;
@property(strong, nonatomic) id<VideoRecordingDelegate> videoDelegate;
@property(nonatomic, strong) FastttCamera *fastCamera;
@property(nonatomic, strong) UIImage *libraryImage;

#pragma mark - Capture Video and Photo

/**
 *  Take picture
 */
- (void)capturePhoto;

/**
 *  Start recording video
 */
- (void)startRecordingVideo;

/**
 *  Stop recording video
 */
- (void)stopRecordingVideo;

#pragma mark - Flash

/**
 *  Flash for camera turned on
 */
- (void)turnFlashOn;

/**
 *  Flash is turned off or on depending on the lighting in the environment
 */
- (void)turnFlashAuto;

/**
 *  Flash for camera turned off
 */
- (void)turnFlashOff;

#pragma mark - Rear and Front Camera

/**
 *  Turn on front facing camera
 */
- (void)turnOnFrontCamera;

/**
 *  Turn on rear facing camera
 */
- (void)turnOnRearCamera;

@end
