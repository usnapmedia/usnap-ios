//
//  SSOCameraCaptureHelper.h
//  Wink
//
//  Created by Justin Khan on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMTime.h>
#import "AVCamPreviewView.h"

@protocol SSOCameraDelegate;

@interface SSOCameraCaptureHelper : NSObject {
    AVAssetExportSession *exporter;
}

/**
 *  Need access to the video device input to use flash
 */
@property(nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property(nonatomic) UIInterfaceOrientation interfaceOrientation;
@property(nonatomic, weak) id<SSOCameraDelegate> delegate;

/**
 *  Instantiate camera with preview view
 *
 *  @param previewView
 *  @param orientation
 *
 *  @return
 */
- (instancetype)initWithPreviewView:(AVCamPreviewView *)previewView
                     andOrientation:(UIDeviceOrientation)orientation
                 withDevicePosition:(AVCaptureDevicePosition)devicePosition
                     withFlashState:(AVCaptureFlashMode)flashState;

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

/**
 *  Start and stop video recording
 */
- (void)toggleMovieRecording;

/**
 *  Take a photo
 */
- (void)snapStillImage;

/**
 *  Animation when you take a photo
 */
- (void)runStillImageCaptureAnimation;

/**
 *  Change the camera from front facing to rear facing or vice versa
 */
- (void)changeCameraWithDevicePosition:(AVCaptureDevicePosition)devicePosition;

/**
 *  Set flash mode to on, off, auto
 *
 *  @param flashMode
 *  @param device
 */
+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device;

/**
 *  Turn torch on, off, auto for video
 *
 *  @param torchMode
 *  @param device
 */
+ (void)setTorchMode:(AVCaptureTorchMode)torchMode forDevice:(AVCaptureDevice *)device;

@end

@protocol SSOCameraDelegate

- (void)didFinishCapturingImage:(UIImage *)image withError:(NSError *)error;

- (void)didFinishCapturingVideo:(NSURL *)video withError:(NSError *)error;

@end
