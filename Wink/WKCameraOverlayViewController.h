//
//  WKCameraViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@class WKCameraViewController;

@interface WKCameraOverlayViewController : WKViewController {
    
}

// Image picker
@property (nonatomic, strong) WKCameraViewController *cameraController;

// UI
@property (weak, nonatomic) IBOutlet UILabel *recordingLabel;

@property (weak, nonatomic) IBOutlet UIButton *mediaButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraDeviceButton;

// Button Actions
- (IBAction)mediaButtonTouched:(id)sender;
- (IBAction)photoButtonTouched:(id)sender;
- (IBAction)videoButtonTouched:(id)sender;
- (IBAction)settingsButtonTouched:(id)sender;

- (IBAction)captureButtonTouched:(id)sender;
- (IBAction)flashButtonTouched:(id)sender;
- (IBAction)cameraDeviceButtonTouched:(id)sender;

@end