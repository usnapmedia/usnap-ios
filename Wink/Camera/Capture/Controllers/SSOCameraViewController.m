//
//  SSOCameraViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraViewController.h"
#import "SSOContainerViewController.h"
#import "WKSettingsViewController.h"
#import "WKImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WKNavigationController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "VideoRecordingDelegate.h"
#import "WKEditMediaViewController.h"
#import "SSORoundedAnimatedButton.h"

#define kTotalVideoRecordingTime 30

@interface SSOCameraViewController () <UIAlertViewDelegate, VideoRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                       SSORoundedAnimatedButtonProtocol>

// IBOutlets
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *videoCenteringConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *photoCenteringConstraint;
@property(weak, nonatomic) IBOutlet UIButton *photoButton;
@property(weak, nonatomic) IBOutlet UIButton *videoButton;
@property(weak, nonatomic) IBOutlet UIView *videoAndPhotoContainerView;
@property(weak, nonatomic) IBOutlet UIButton *flashButton;
@property(weak, nonatomic) IBOutlet UIButton *cameraRotationButton;
@property(weak, nonatomic) IBOutlet UILabel *recordingVideoLabel;
@property(weak, nonatomic) IBOutlet UIButton *mediaButton;
@property(weak, nonatomic) IBOutlet UIButton *settingsButton;
@property(weak, nonatomic) IBOutlet UIView *topBlackBar;
@property(weak, nonatomic) IBOutlet UIButton *captureButton;
@property(weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property(weak, nonatomic) IBOutlet SSORoundedAnimatedButton *animatedCaptureButton;

// View Controllers
@property(weak, nonatomic) SSOContainerViewController *containerViewController;
@property(weak, nonatomic) WKEditMediaViewController *mediaEditViewController;

// Views
@property(strong, nonatomic) UIView *blackView;

// Data
@property(nonatomic) BOOL isVideoOn;
@property(nonatomic) BOOL isFlashOn;
@property(nonatomic) BOOL isCameraRearFacing;
@property(nonatomic) BOOL isVideoRecording;

@property(nonatomic) NSInteger videoTimeRemaining;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation SSOCameraViewController

#pragma mark - View Controller Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self initializeData];

    // Initialize state of camera to setup UI
    [self initializeStateOfCamera];

    // Initialize UI
    // Start with the photo button in the middle
    [self initializeUI];
    [self initializeGestures];

    [self initAnimatedButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self animateCameraRollImageChange];
}

#pragma mark - Utilities

- (void)initAnimatedButton {
    self.animatedCaptureButton.delegate = self;
    self.animatedCaptureButton.circleColor = [UIColor blueColor];
    self.animatedCaptureButton.circleOpacity = 0.8;
    self.animatedCaptureButton.circleLineWidth = 20;
}

/**
 *  Intialize data
 */
- (void)initializeData {
    self.videoTimeRemaining = kTotalVideoRecordingTime;
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
    if (self.isVideoOn) {
        [self swapPhotoAndVideoButtonsWithButtonToCenter:self.videoButton
                                  andCenteringConstraint:self.videoCenteringConstraint
                                     andConstraintToMove:self.photoCenteringConstraint
                                  withLeftwardsDirection:YES
                                                animated:YES];

    } else {
        [self swapPhotoAndVideoButtonsWithButtonToCenter:self.photoButton
                                  andCenteringConstraint:self.photoCenteringConstraint
                                     andConstraintToMove:self.videoCenteringConstraint
                                  withLeftwardsDirection:NO
                                                animated:YES];
    }

    // Setup UI for photo/video buttons
    [self.photoButton setAttributedTitle:[self setupUIForButtonWithText:@"Photo"] forState:UIControlStateSelected];
    [self.videoButton setAttributedTitle:[self setupUIForButtonWithText:@"Video"] forState:UIControlStateSelected];

    // Setup UI for video recording label
    [self updateVideoUI];
    [self updateFlashUI];
    [self updateRearCameraFacingUI];

    // Add black view in between switching between photo and video
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [self.containerView addSubview:self.blackView];
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

/**
 *  Update flash button UI
 */
- (void)updateFlashUI {
    // Change flash button icon
    if (self.isFlashOn) {
        if (self.isVideoOn) {
            [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
            [self.containerViewController.cameraContainerVC turnFlashOff];

        } else {
            [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
            [self.containerViewController.cameraContainerVC turnFlashOn];
        }
    } else {
        [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        [self.containerViewController.cameraContainerVC turnFlashOff];
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

        //        [self.containerViewController.cameraContainerVC turnRearCameraOn];

    } else {
        if (!self.isVideoOn) {
            self.flashButton.hidden = NO;
        } else {
            self.flashButton.hidden = YES;
        }
        //        [self.containerViewController.cameraContainerVC turnRearCameraOff];
    }
}

/**
 *  Update the UI when the video is recording
 */
- (void)updateVideoRecordingUI {
    if (self.isVideoRecording) {
        self.flashButton.hidden = YES;
        self.cameraRotationButton.hidden = YES;
        self.mediaButton.hidden = YES;
        self.settingsButton.hidden = YES;
        self.videoAndPhotoContainerView.hidden = YES;
        self.recordingVideoLabel.hidden = NO;
    } else {
        self.flashButton.hidden = YES;
        self.cameraRotationButton.hidden = NO;
        self.mediaButton.hidden = NO;
        self.settingsButton.hidden = NO;
        self.videoAndPhotoContainerView.hidden = NO;
        self.recordingVideoLabel.hidden = YES;
    }
}

/**
 *  Animate black view to cover the camera view and disable interaction to give enough time to switch between photo and video
 */
- (void)animateBlackViewOntoScreen {

    self.animatedCaptureButton.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.54
        delay:0.0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
          self.blackView.alpha = 0.7;
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.2
                                delay:0.0
                              options:UIViewAnimationOptionCurveLinear
                           animations:^{
                             self.blackView.alpha = 0.0;
                             self.animatedCaptureButton.userInteractionEnabled = YES;
                           }
                           completion:nil];
        }];
}

/**
 *  While recording this code will update the timer to count down
 *
 *  @param secondsRemaining
 */
- (void)updateVideoRecordingLabel:(NSTimer *)timer {
    NSString *recordString = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"REC", @"")];
    NSString *timeString = [NSString stringWithFormat:@"%02i", (int)self.videoTimeRemaining];
    NSString *fullString = [NSString stringWithFormat:@"%@ %@", recordString, timeString];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont winkFontAvenirWithSize:16.0f] range:[fullString rangeOfString:recordString]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[fullString rangeOfString:recordString]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont winkFontAvenirWithSize:22.0f] range:[fullString rangeOfString:timeString]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[fullString rangeOfString:timeString]];

    self.recordingVideoLabel.attributedText = attrString;

    self.videoTimeRemaining--;
}

/**
 *  Create an attributed string for the photo/video buttons
 *
 *  @param text - Button text
 *
 *  @return
 */
- (NSMutableAttributedString *)setupUIForButtonWithText:(NSString *)text {
    NSMutableAttributedString *attrStringSelected = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(text, nil).uppercaseString];
    [attrStringSelected addAttribute:NSKernAttributeName
                               value:[NSNumber numberWithInteger:2]
                               range:[attrStringSelected.string rangeOfString:attrStringSelected.string]];
    [attrStringSelected addAttribute:NSForegroundColorAttributeName
                               value:[UIColor yellowTextColorWithAlpha:1.0f]
                               range:[attrStringSelected.string rangeOfString:attrStringSelected.string]];

    return attrStringSelected;
}

/**
 *  Initialize swiping gestures for video and photo
 */
- (void)initializeGestures {
    // Add the swipe gestures
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];

    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
}

/**
 *  Animate the photo and video buttons positions using constraints
 */
- (void)animatePhotoVideoSwitch {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                       [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

/**
 *  Swap video and photo buttons
 *
 *  @param buttonToCenter     Button that you would like to center
 *  @param constraintToCenter Constraint that you will use to center the button
 *  @param constraintToShift  Constraint of the button that you will shift to right or left out of the way
 *  @param isMovingLeftwards  Check if the button you want to center is moving leftwards
 *  @param animated
 */
- (void)swapPhotoAndVideoButtonsWithButtonToCenter:(UIButton *)buttonToCenter
                            andCenteringConstraint:(NSLayoutConstraint *)constraintToCenter
                               andConstraintToMove:(NSLayoutConstraint *)constraintToShift
                            withLeftwardsDirection:(BOOL)isMovingLeftwards
                                          animated:(BOOL)animated {
    // Shift photo button to the left and move video button to the center
    float widthOfButtonToCenter = buttonToCenter.frame.size.width;
    float widthOfScreenMinusButtonToCenter = self.videoAndPhotoContainerView.frame.size.width / 2 - widthOfButtonToCenter / 2;

    if (isMovingLeftwards) {
        constraintToShift.constant = widthOfScreenMinusButtonToCenter / 2 + widthOfButtonToCenter / 2;
    } else {
        constraintToShift.constant = -(widthOfScreenMinusButtonToCenter / 2 + widthOfButtonToCenter / 2);
    }
    constraintToCenter.constant = 0;

    // Animate the photo and video buttons positions
    if (animated) {
        [self animatePhotoVideoSwitch];
    }
}

/**
 *  Add an animation to the camera roll preview image when we take a picture and come back to camera view
 */
- (void)animateCameraRollImageChange {

    if (self.containerViewController.cameraContainerVC.libraryImage) {

        [UIView animateWithDuration:0.3
            animations:^{
              self.mediaButton.alpha = 0.1;
            }
            completion:^(BOOL finished) {

              [UIView animateWithDuration:0.3
                               animations:^{
                                 [self.mediaButton setImage:self.containerViewController.cameraContainerVC.libraryImage forState:UIControlStateNormal];

                                 self.mediaButton.alpha = 1;
                               }];
            }];
    }
}
#pragma mark - UIGestureRecognizer

/**
 *  When the user swipes left or right, change between the video or photo container
 *
 *  @param swipeGesture
 */
- (IBAction)swipeGestureAction:(UISwipeGestureRecognizer *)swipeGesture {
    if (swipeGesture.direction & UISwipeGestureRecognizerDirectionLeft) {
        [self videoContainerButtonPushed:self.videoButton];

    } else if (swipeGesture.direction & UISwipeGestureRecognizerDirectionRight) {
        [self photoContainerButtonPushed:self.photoButton];
    }
}

#pragma mark - Prepare for Segue / Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Set up container view controller
    if ([segue.identifier isEqualToString:kCameraContainerSegue]) {
        SSOContainerViewController *containerViewController = (SSOContainerViewController *)segue.destinationViewController;

        self.isVideoOn = [[NSUserDefaults standardUserDefaults] boolForKey:kIsVideoOn];

        [containerViewController setInitialViewController];
        self.containerViewController = containerViewController;

        if (self.isVideoOn) {
            //            self.containerViewController.cameraContainerVC.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];

        } else {
            //            self.containerViewController.cameraContainerVC.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        }

        // Store the container view controller in a property to be used to swap view controller
        self.containerViewController = containerViewController;

        // Set delegate for video view controller to enable user interaction in this vc after the video is done recording
        self.containerViewController.cameraContainerVC.videoDelegate = self;
    }
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

#pragma mark - IBActions

#pragma mark Video/Photo Buttons

- (IBAction)photoContainerButtonPushed:(id)sender {
    // Animate moving the photo and video buttons with constraints
    [self swapPhotoAndVideoButtonsWithButtonToCenter:self.photoButton
                              andCenteringConstraint:self.photoCenteringConstraint
                                 andConstraintToMove:self.videoCenteringConstraint
                              withLeftwardsDirection:NO
                                            animated:YES];

    self.isVideoOn = NO;
    self.isFlashOn = [[NSUserDefaults standardUserDefaults] boolForKey:kIsFlashOn];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsVideoOn];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self updateVideoUI];
    [self updateFlashUI];
    [self updateRearCameraFacingUI];

    [self animateBlackViewOntoScreen];
}

- (IBAction)videoContainerButtonPushed:(id)sender {
    // Animate moving the photo and video buttons with constraints
    [self swapPhotoAndVideoButtonsWithButtonToCenter:self.videoButton
                              andCenteringConstraint:self.videoCenteringConstraint
                                 andConstraintToMove:self.photoCenteringConstraint
                              withLeftwardsDirection:YES
                                            animated:YES];

    self.isVideoOn = YES;
    self.isFlashOn = NO;

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsVideoOn];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self updateVideoUI];
    [self updateFlashUI];
    [self updateRearCameraFacingUI];

    [self animateBlackViewOntoScreen];
}

#pragma mark Corner Icons

- (IBAction)flashButtonTouched:(id)sender {
    if (self.isFlashOn) {
        self.isFlashOn = NO;

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsFlashOn];

    } else {
        self.isFlashOn = YES;

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFlashOn];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];

    [self updateFlashUI];
}

- (IBAction)mediaButtonTouched:(id)sender {
    // Open a controller that holds the user's photos and videos
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Photo or video?", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Video", nil), NSLocalizedString(@"Photo", nil), nil];
    [alertView show];
}

- (IBAction)settingsButtonTouched:(id)sender {

    WKSettingsViewController *controller = [[WKSettingsViewController alloc] initWithNibName:@"WKSettingsViewController" bundle:nil];
    WKNavigationController *navController = [[WKNavigationController alloc] initWithRootViewController:controller];
    [self.navigationController.visibleViewController presentViewController:navController animated:YES completion:nil];
}

- (IBAction)cameraDeviceButtonTouched:(id)sender {
    if (self.isCameraRearFacing) {
        self.isCameraRearFacing = NO;

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsCameraRearFacing];

        [self.containerViewController.cameraContainerVC turnOnFrontCamera];

    } else {
        self.isCameraRearFacing = YES;

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsCameraRearFacing];

        [self.containerViewController.cameraContainerVC turnOnRearCamera];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];

    [self updateRearCameraFacingUI];
}

#pragma mark Capture Button

- (IBAction)captureButtonPushed:(id)sender {
    // Send message to photo or video view controller to take photo or video
    if (self.isVideoOn) {

        if (self.isVideoRecording) {
            [self.timer invalidate];

            self.videoTimeRemaining = kTotalVideoRecordingTime;

            self.isVideoRecording = NO;

            // Stop recording
            [self.containerViewController.cameraContainerVC stopRecordingVideo];

            // Loading HUD until the video is done uploading
            [SVProgressHUD show];

            // Disable user interaction
            self.view.userInteractionEnabled = NO;
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateVideoRecordingLabel:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

            [self.timer fire];
            self.isVideoRecording = YES;

            // Start recording
            [self.containerViewController.cameraContainerVC startRecordingVideo];
        }

        [self updateVideoRecordingUI];

    } else {
        [self.containerViewController.cameraContainerVC capturePhoto];
    }
}

#pragma mark - SSORoundedAnimatedButtonProtocol

- (void)didStartAnimation:(SSORoundedAnimatedButton *)button {
    //    if (self.isVideoOn) {
    //        if (!self.isVideoRecording) {
    //            self.isVideoRecording = YES;

    [self.containerViewController.cameraContainerVC startRecordingVideo];

    //        }
    //    }
    //
}

- (void)didFinishAnimation:(SSORoundedAnimatedButton *)button {

    [self.containerViewController.cameraContainerVC stopRecordingVideo];
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
#pragma mark - VideoRecordingDelegate

- (void)enableUserInteraction {
    self.view.userInteractionEnabled = YES;
}

@end
