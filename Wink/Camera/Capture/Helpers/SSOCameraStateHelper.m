//
//  SSOCameraStateHelper.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraStateHelper.h"
#import "Constants.h"

@interface SSOCameraStateHelper ()

@end

@implementation SSOCameraStateHelper

@synthesize flashState = _flashState;
@synthesize torchState = _torchState;
@synthesize devicePosition = _devicePosition;

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];

    });
    return sharedInstance;
}

#pragma mark - Setter

- (void)setFlashState:(AVCaptureFlashMode)flashState {
    _flashState = flashState;
    [[NSUserDefaults standardUserDefaults] setInteger:_flashState forKey:kFlashState];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTorchState:(AVCaptureTorchMode)torchState {
    _torchState = torchState;
    [[NSUserDefaults standardUserDefaults] setInteger:_torchState forKey:kTorchState];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDevicePosition:(AVCaptureDevicePosition)devicePosition {
    _devicePosition = devicePosition;
    [[NSUserDefaults standardUserDefaults] setInteger:_devicePosition forKey:kDevicePosition];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getter

- (AVCaptureFlashMode)flashState {
    if (!_flashState) {
        _flashState = [[[NSUserDefaults standardUserDefaults] objectForKey:kFlashState] integerValue];
    }
    return _flashState;
}

- (AVCaptureTorchMode)torchState {
    if (!_torchState) {
        _torchState = [[[NSUserDefaults standardUserDefaults] objectForKey:kTorchState] integerValue];
    }
    return _torchState;
}

- (AVCaptureDevicePosition)devicePosition {
    if (!_devicePosition) {
        _devicePosition = [[[NSUserDefaults standardUserDefaults] objectForKey:kDevicePosition] integerValue];
        if (_devicePosition == 0) {
            _devicePosition = 1;
        }
    }
    return _devicePosition;
}

@end
