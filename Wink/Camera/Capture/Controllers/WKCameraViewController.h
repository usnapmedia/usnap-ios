//
//  WKCameraViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"
#import "WKImagePickerController.h"
#import "FastttCamera.h"

@interface WKCameraViewController : WKViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, FastttCameraDelegate>

// Camera controller
@property(nonatomic, strong) WKImagePickerController *cameraImagePickerController;
@property(nonatomic, strong) FastttCamera *photoCamera;

// Button Actions
- (void)presentMediaPickerControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock;
- (void)presentSettingsControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock;

@end
