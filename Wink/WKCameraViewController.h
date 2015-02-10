//
//  WKCameraViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"
#import "WKImagePickerController.h"

@interface WKCameraViewController : WKViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
}

// Camera controller
@property (nonatomic, strong) WKImagePickerController *cameraImagePickerController;

// Button Actions
- (void)presentMediaPickerControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock;
- (void)presentSettingsControllerAnimated:(BOOL)animated completed:(void (^)(void))completionBlock;

@end
