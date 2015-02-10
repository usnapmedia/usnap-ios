//
//  WKCameraViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-28.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKCameraOverlayViewController.h"
#import "WKCameraViewController.h"

@interface WKCameraOverlayViewController ()
@property (nonatomic) BOOL recording;
@property (nonatomic, strong) NSDate *recordingStartDate;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CGAffineTransform cameraViewPhotoTransform;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@end

@implementation WKCameraOverlayViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the swipe gestures
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
    // Setup the display link
    [self.displayLink invalidate], self.displayLink = nil;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdated)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // Setup the record label
    self.recordingLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.recordingLabel.layer.shadowOpacity = 0.75f;
    self.recordingLabel.layer.shadowRadius = 1.0f;
    self.recordingLabel.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    // Setup the camera view photo transform
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat cameraRatio = 4.0f/3.0f;
    CGFloat scale = screenSize.height/(screenSize.height/cameraRatio);
    CGFloat translation = (screenSize.height - (screenSize.height/cameraRatio))/2.0f;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, translation);
    transform = CGAffineTransformScale(transform, scale, scale);
    self.cameraViewPhotoTransform = transform;
    
    // Setup UI
    [self setupUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Reset recording (in case you reached max time limit)
    self.recording = NO;
    self.recordingStartDate = nil;
    [self updateUI];
}

#pragma mark - Display Link Method

- (void)displayLinkUpdated {
    if (self.recording) {
        [self updateRecordingTimerUI];
    }
}

#pragma mark - Setup & Update UI

- (void)setupUI {

    // Setup the buttons
    UIFont *buttonFont = [UIFont winkFontAvenirWithSize:self.isPhone ? 14.0f : 24.0f];
    NSMutableAttributedString *photoAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Photo", @"").uppercaseString];
    [photoAttrString addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[photoAttrString.string rangeOfString:photoAttrString.string]];
    [photoAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[photoAttrString.string rangeOfString:photoAttrString.string]];
    [self.photoButton setAttributedTitle:photoAttrString forState:UIControlStateNormal];
    
    NSMutableAttributedString *photoAttrStringSelected = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Photo", @"").uppercaseString];
    [photoAttrStringSelected addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[photoAttrStringSelected.string rangeOfString:photoAttrStringSelected.string]];
    [photoAttrStringSelected addAttribute:NSForegroundColorAttributeName value:[UIColor yellowTextColorWithAlpha:1.0f] range:[photoAttrStringSelected.string rangeOfString:photoAttrStringSelected.string]];
    [self.photoButton setAttributedTitle:photoAttrStringSelected forState:UIControlStateSelected];
    self.photoButton.titleLabel.font = buttonFont;
    
    self.photoButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.photoButton.layer.shadowOpacity = 0.75f;
    self.photoButton.layer.shadowRadius = 1.0f;
    self.photoButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    NSMutableAttributedString *videoAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Video", @"").uppercaseString];
    [videoAttrString addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[videoAttrString.string rangeOfString:videoAttrString.string]];
    [videoAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[videoAttrString.string rangeOfString:videoAttrString.string]];
    [self.videoButton setAttributedTitle:videoAttrString forState:UIControlStateNormal];
    
    NSMutableAttributedString *videoAttrStringSelected = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Video", @"").uppercaseString];
    [videoAttrStringSelected addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:2] range:[videoAttrStringSelected.string rangeOfString:videoAttrStringSelected.string]];
    [videoAttrStringSelected addAttribute:NSForegroundColorAttributeName value:[UIColor yellowTextColorWithAlpha:1.0f] range:[videoAttrStringSelected.string rangeOfString:videoAttrStringSelected.string]];
    [self.videoButton setAttributedTitle:videoAttrStringSelected forState:UIControlStateSelected];
    self.videoButton.titleLabel.font = buttonFont;
    
    self.videoButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.videoButton.layer.shadowOpacity = 0.75f;
    self.videoButton.layer.shadowRadius = 1.0f;
    self.videoButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    // Set flash to off by default
    if (!self.isPhone) {
        [self.flashButton removeFromSuperview];
    }
    self.flashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    // Update UI
    [self updateUI];
}

- (void)updateUI {
    
    // Setup for photo
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (self.cameraController.cameraImagePickerController.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto) {
        self.cameraController.cameraImagePickerController.cameraViewTransform = self.cameraViewPhotoTransform;
        
        // Front camera
        if (self.cameraController.cameraImagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
            self.flashButton.hidden = YES;
        }
        // Rear camera
        else {
            self.flashButton.hidden = NO;
        }
        
        self.videoButton.selected = NO;
        self.photoButton.selected = YES;
        
        self.recordingLabel.hidden = YES;
        self.photoButton.hidden = NO;
        self.cameraDeviceButton.hidden = NO;
        self.mediaButton.hidden = NO;
        self.settingsButton.hidden = NO;
    }
    // Setup for video
    else {
        self.cameraController.cameraImagePickerController.cameraViewTransform = CGAffineTransformIdentity;
        
        self.flashButton.hidden = YES;
        self.videoButton.selected = YES;
        self.photoButton.selected = NO;
        
        transform = CGAffineTransformMakeTranslation(self.captureButton.center.x - self.videoButton.center.x, 0.0f);
        
        self.recordingLabel.hidden = !self.recording;
        self.photoButton.hidden = self.recording;
        self.cameraDeviceButton.hidden = self.recording;
        self.mediaButton.hidden = self.recording;
        self.settingsButton.hidden = self.recording;
    }
    
    // Animate the photo and video buttons positions
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.photoButton.transform = transform;
        self.videoButton.transform = transform;
        
    } completion:nil];
    
    // Flash: OFF
    if (self.flashMode == UIImagePickerControllerCameraFlashModeOff) {
        [self.flashButton setImage:[UIImage imageNamed:self.isPhone ? @"flashButtonIconOFF.png" : @"cameraFlashButtonOFF_iPad.png"] forState:UIControlStateNormal];
    }
    // Flash: AUTO
    else if (self.flashMode == UIImagePickerControllerCameraFlashModeAuto) {
        [self.flashButton setImage:[UIImage imageNamed:self.isPhone ? @"flashButtonIconAUTO.png" : @"cameraFlashButtonAUTO_iPad.png"] forState:UIControlStateNormal];
    }
    // Flash: ON
    else if (self.flashMode == UIImagePickerControllerCameraFlashModeOn) {
        [self.flashButton setImage:[UIImage imageNamed:self.isPhone ? @"flashButtonIconON.png" : @"cameraFlashButtonON_iPad.png"] forState:UIControlStateNormal];
    }
}

- (void)updateRecordingTimerUI {
    NSTimeInterval totalSeconds = [[NSDate date] timeIntervalSinceDate:self.recordingStartDate];
    CGFloat secondsRemaining = MAX(roundf(self.cameraController.cameraImagePickerController.videoMaximumDuration - totalSeconds), 0);
    
    NSString *recordString = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"REC", @"")];
    NSString *timeString = [NSString stringWithFormat:@"%02i", (int)secondsRemaining];
    NSString *fullString = [NSString stringWithFormat:@"%@ %@", recordString, timeString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont winkFontAvenirWithSize:self.isPhone ? 16.0f : 32.0f] range:[fullString rangeOfString:recordString]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[fullString rangeOfString:recordString]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont winkFontAvenirWithSize:self.isPhone ? 22.0f : 44.0f] range:[fullString rangeOfString:timeString]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[fullString rangeOfString:timeString]];
    self.recordingLabel.attributedText = attrString;
}

#pragma mark - Swipe Gesture Action

- (IBAction)swipeGestureAction:(UISwipeGestureRecognizer *)swipeGesture {
    if (swipeGesture.direction & UISwipeGestureRecognizerDirectionLeft) {
        [self videoButtonTouched:self.videoButton];
    }
    else if (swipeGesture.direction & UISwipeGestureRecognizerDirectionRight) {
        [self photoButtonTouched:self.photoButton];
    }
}

#pragma mark - Button Actions

- (IBAction)mediaButtonTouched:(id)sender {
    [self.cameraController presentMediaPickerControllerAnimated:YES completed:nil];
}

- (IBAction)photoButtonTouched:(id)sender {
    self.cameraController.cameraImagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self updateUI];
}

- (IBAction)videoButtonTouched:(id)sender {
    self.cameraController.cameraImagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    [self updateUI];
}

- (IBAction)settingsButtonTouched:(id)sender {
    [self.cameraController presentSettingsControllerAnimated:YES completed:nil];
}

- (IBAction)captureButtonTouched:(id)sender {
    
    // Take image
    if (self.photoButton.selected) {
        self.recording = NO;
        self.cameraController.cameraImagePickerController.cameraFlashMode = self.flashMode;
        [self.cameraController.cameraImagePickerController takePicture];
    }
    // Start recording
    else if (self.videoButton.selected && !self.recording) {
        self.recording = YES;
        self.recordingStartDate = [NSDate date];
        [self updateRecordingTimerUI];
        [self.cameraController.cameraImagePickerController startVideoCapture];
    }
    // Stop recording
    else if (self.videoButton.selected && self.recording) {
        self.recording = NO;
        self.recordingStartDate = nil;
        [self.cameraController.cameraImagePickerController stopVideoCapture];
    }
    
    // Update the UI
    [self updateUI];
}

- (IBAction)flashButtonTouched:(id)sender {
    
    // Flash: AUTO
    if (self.flashMode == UIImagePickerControllerCameraFlashModeOn) {
        self.flashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
    // Flash: OFF
    else if (self.flashMode == UIImagePickerControllerCameraFlashModeAuto) {
        self.flashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    // Flash: ON
    else if (self.flashMode == UIImagePickerControllerCameraFlashModeOff) {
        self.flashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    
    [self updateUI];
}

- (IBAction)cameraDeviceButtonTouched:(id)sender {
    
    // Front Camera
    if (self.cameraController.cameraImagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        self.cameraController.cameraImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    // Rear camera
    else {
        self.cameraController.cameraImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    [self updateUI];
}

@end
