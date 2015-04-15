//
//  SSOCameraCaptureHelper.h
//  Wink
//
//  Created by Justin Khan on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVCamPreviewView.h"

@interface SSOCameraCaptureHelper : NSObject

@property(nonatomic) UIInterfaceOrientation interfaceOrientation;

- (instancetype)initWithPreviewView:(AVCamPreviewView *)previewView andOrientation:(UIInterfaceOrientation)orientation;

- (void)toggleMovieRecording;
- (void)changeCamera;
- (void)snapStillImage;

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end
