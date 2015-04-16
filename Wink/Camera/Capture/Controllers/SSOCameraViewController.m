//
//  SSOCameraViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraViewController.h"
#import "WKSettingsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WKNavigationController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "WKEditMediaViewController.h"
#import "SSORoundedAnimatedButton.h"
#import "AVCamPreviewView.h"
#import "SSOCameraCaptureHelper.h"

#define kTotalVideoRecordingTime 30

@interface SSOCameraViewController () <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSORoundedAnimatedButtonProtocol,
                                       SSOCameraDelegate>

// IBOutlets
@property(weak, nonatomic) IBOutlet UIButton *flashButton;
@property(weak, nonatomic) IBOutlet UIButton *cameraRotationButton;
@property(weak, nonatomic) IBOutlet UIButton *mediaButton;
@property(weak, nonatomic) IBOutlet UIView *topBlackBar;
@property(weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property(weak, nonatomic) IBOutlet SSORoundedAnimatedButton *animatedCaptureButton;
@property(weak, nonatomic) IBOutlet AVCamPreviewView *cameraPreviewView;

// View Controllers
@property(weak, nonatomic) WKEditMediaViewController *mediaEditViewController;

// Data
@property(nonatomic) BOOL isVideoOn;
@property(nonatomic) BOOL isFlashOn;
@property(nonatomic) BOOL isCameraRearFacing;
@property(nonatomic) BOOL isVideoRecording;
@property(nonatomic) BOOL isRotationAllowed;
@property(strong, nonatomic) SSOCameraCaptureHelper *cameraCaptureHelper;

@end

@implementation SSOCameraViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self initializeData];

    // Initialize state of camera to setup UI
    [self initializeStateOfCamera];

    // Initialize UI
    // Start with the photo button in the middle
    [self initializeUI];

    [self initAnimatedButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self animateCameraRollImageChange];
}

#pragma mark - Orientation

/**
 *  View controller method telling us what the orientation of the device is
 *
 *  @param toInterfaceOrientation
 *  @param duration
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.cameraCaptureHelper willRotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - Utilities

/**
 *  Initialize animated button
 */
- (void)initAnimatedButton {
    self.animatedCaptureButton.delegate = self;
    self.animatedCaptureButton.circleColor = [UIColor blueColor];
    self.animatedCaptureButton.circleOpacity = 0.8;
    self.animatedCaptureButton.circleLineWidth = 20;
    [self.animatedCaptureButton resetAnimation];
}

/**
 *  Intialize data
 */
- (void)initializeData {
    self.cameraCaptureHelper = [[SSOCameraCaptureHelper alloc] initWithPreviewView:self.cameraPreviewView andOrientation:[self interfaceOrientation]];
    self.cameraCaptureHelper.delegate = self;
}

/**
 *  The state of the camera is if the flash is on or not, the video is on or not, is the camera rear facing
 */
- (void)initializeStateOfCamera {
    self.isFlashOn = [[NSUserDefaults standardUserDefaults] boolForKey:kIsFlashOn];
    self.isCameraRearFacing = [[NSUserDefaults standardUserDefaults] boolForKey:kIsCameraRearFacing];
}

/**
 *  InitializeUI
 */
- (void)initializeUI {

    // Allow the user to rotate the screen when the view just appeared
    self.isRotationAllowed = YES;
    self.isVideoRecording = NO;

    // Setup UI for video recording label
    [self updateVideoUI];
    [self updateFlashUI];
    [self updateRearCameraFacingUI];

    [self.view bringSubviewToFront:self.animatedCaptureButton];
}
/**
 *  Update Video UI
 */
- (void)updateVideoUI {
    // Remove flash button
    if (self.isVideoOn) {
        self.flashButton.hidden = YES;
    } else if (self.isFlashOn) {
        self.flashButton.hidden = NO;
    } else {
        self.flashButton.hidden = YES;
    }
}

- (BOOL)shouldAutorotate {

    return self.isRotationAllowed;
}

/**
 *  Update flash button UI
 */
- (void)updateFlashUI {
    // Change flash button icon
    if (self.isFlashOn) {
        if (self.isVideoOn) {
            [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];

        } else {
            [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        }
    } else {
        [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    }
}

/**
 *  Update rear facing camera button UI
 */
- (void)updateRearCameraFacingUI {
    // Remove flash button
    // Send a message to the photo/video controller to change camera direction
    if (self.isCameraRearFacing) {
        self.flashButton.hidden = YES;

    } else {
        if (!self.isVideoOn) {
            self.flashButton.hidden = NO;
        } else {
            self.flashButton.hidden = YES;
        }
    }
}

/**
 *  Add an animation to the camera roll preview image when we take a picture and come back to camera view
 */
- (void)animateCameraRollImageChange {

    // TODO: Fix this with the new helper
    // if (self.containerViewController.cameraContainerVC.libraryImage) {

    [UIView animateWithDuration:0.3
        animations:^{
          self.mediaButton.alpha = 0.1;
        }
        completion:^(BOOL finished) {

          [UIView animateWithDuration:0.3
                           animations:^{
                             //           [self.mediaButton setImage:self.containerViewController.cameraContainerVC.libraryImage forState:UIControlStateNormal];

                             self.mediaButton.alpha = 1;
                           }];
        }];
    //  }
}

/**
 *  Init and present the UIImagePickerController to allow the user to select a photo or video from camera roll
 */
- (void)displayCamerallRollPickerVC {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.navigationBarHidden = NO;
    controller.delegate = self;
    controller.toolbarHidden = NO;
    controller.mediaTypes = @[ (NSString *)kUTTypeImage, (NSString *)kUTTypeMovie ];
    [self presentViewController:controller animated:YES completion:nil];
}

/**
 *  Push to EditMediaVC and pass it the image or video
 *
 *  @param mediaDic the dic returned by the UIImagePickerViewDelegate
 */
- (void)pushToEditVCWithMedia:(NSDictionary *)mediaDic {

    NSString *mediaType = [mediaDic objectForKey:UIImagePickerControllerMediaType];
    NSURL *mediaURL = nil;
    UIImage *image = nil;

    // Check what kind of data is returned
    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeImage)) {
        image = [mediaDic objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [mediaDic objectForKey:UIImagePickerControllerOriginalImage];
        }
    } else if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {
        mediaURL = [mediaDic objectForKey:UIImagePickerControllerMediaURL];
        if (mediaURL == nil) {
            mediaURL = [mediaDic objectForKey:UIImagePickerControllerReferenceURL];
        }
    }

    // Instanciate the editMediaVC and pass it the image and video url
    WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
    controller.mediaURL = mediaURL;
    controller.image = image;
    // Push to editMediaVC
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Corner Icons

- (IBAction)flashButtonTouched:(id)sender {

    if (self.isFlashOn) {
        self.isFlashOn = NO;

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsFlashOn];

        //        [SSOCameraCaptureHelper setFlashMode:AVCaptureFlashModeOn forDevice:AVCaptureDevicePositionFront];

    } else {
        self.isFlashOn = YES;

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFlashOn];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];

    [self updateFlashUI];
}

- (IBAction)mediaButtonTouched:(id)sender {

    // Open a controller that holds the user's photos and videos
    [self displayCamerallRollPickerVC];

    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Photo or video?", nil)
    //                                                        message:nil
    //                                                       delegate:self
    //                                              cancelButtonTitle:nil
    //                                              otherButtonTitles:NSLocalizedString(@"Video", nil), NSLocalizedString(@"Photo", nil), nil];
    //    [alertView show];
}

- (IBAction)cameraDeviceButtonTouched:(id)sender {
    [self.cameraCaptureHelper changeCamera];

    // Update the UI
    if (self.isCameraRearFacing) {
        self.isCameraRearFacing = NO;
    } else {
        self.isCameraRearFacing = YES;
    }
    [self updateRearCameraFacingUI];
}

#pragma mark Capture Button

- (IBAction)captureButtonPushed:(id)sender {

    [self.cameraCaptureHelper runStillImageCaptureAnimation];

    [self.cameraCaptureHelper snapStillImage];
}

#pragma mark - SSORoundedAnimatedButtonProtocol

- (void)didStartLongPressGesture:(SSORoundedAnimatedButton *)button {

    [self.cameraCaptureHelper toggleMovieRecording];
    self.isRotationAllowed = NO;
    self.isVideoRecording = YES;
}

- (void)didFinishLongPressGesture:(SSORoundedAnimatedButton *)button {

    [button pauseAnimation];

    [self.cameraCaptureHelper toggleMovieRecording];
    self.isVideoRecording = NO;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // Open library of photos and videos
    BOOL allowsEditing = NO;
    NSArray *mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];

    if (buttonIndex == 0) {
        allowsEditing = YES;
        mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    }

    [self displayCamerallRollPickerVC];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *mediaURL = nil;

    if (UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeMovie)) {
        mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (mediaURL == nil) {
            mediaURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        }
    }
    // Pass the dictionary in order to push to editMediaVC
    [self pushToEditVCWithMedia:info];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden // iOS8 definitely needs this one. checked.
{
    return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return nil;
}

- (void)enableUserInteraction {
    self.view.userInteractionEnabled = YES;
}

#pragma mark - SSOCameraDelegate

- (void)didFinishCapturingImage:(UIImage *)image withError:(NSError *)error {

    if (!error) {
        // Edit the selected media
        WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
        controller.image = image;
        [self.navigationController pushViewController:controller animated:YES];

    } else {
    }
}

- (void)didFinishCapturingVideo:(NSURL *)video withError:(NSError *)error {

    if (!error) {
        // Edit the selected media
        WKEditMediaViewController *controller = [[WKEditMediaViewController alloc] initWithNibName:@"WKEditMediaViewController" bundle:nil];
        controller.mediaURL = video;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
    }
}

@end
