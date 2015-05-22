//
//  SSOCameraStateHelper.h
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOCameraStateHelper : NSObject

@property(nonatomic) AVCaptureFlashMode flashState;
@property(nonatomic) AVCaptureTorchMode torchState;
@property(nonatomic) AVCaptureDevicePosition devicePosition;

/**
 *  Return SSOCameraStateHelper singleton instance
 *
 *  @return reference to the singleton
 */

+ (instancetype)sharedInstance;

@end
