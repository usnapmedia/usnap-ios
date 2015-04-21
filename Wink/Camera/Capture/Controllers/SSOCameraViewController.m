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
#import "SSOOrientationHelper.h"
#import "UINavigationController+SSOLockedNavigationController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <Masonry.h>

#define kTotalVideoRecordingTime 30

@interface SSOCameraViewController () <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSORoundedAnimatedButtonProtocol,
                                       SSOCameraDelegate>

// IBOutlets
@property(weak, nonatomic) IBOutlet UIButton *flashButton;
@property(weak, nonatomic) IBOutlet UIButton *cameraRotationButton;
@property(weak, nonatomic) IBOutlet UIButton *profileButton;
@property(weak, nonatomic) IBOutlet UIButton *mediaButton;
@property(weak, nonatomic) IBOutlet UIView *topBlackBar;
@property(weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property(weak, nonatomic) IBOutlet SSORoundedAnimatedButton *animatedCaptureButton;
@property(weak, nonatomic) IBOutlet AVCamPreviewView *cameraPreviewView;
@property(strong, nonatomic) UIVisualEffectView *effectView;
@property(strong, nonatomic) UIView *blurEffectview;

// View Controllers
@property(weak, nonatomic) WKEditMediaViewController *mediaEditViewController;

// Data
@property(nonatomic) BOOL isVideoOn;
@property(nonatomic) AVCaptureFlashMode flashState;
@property(nonatomic) AVCaptureTorchMode torchState;
@property(nonatomic) AVCaptureDevicePosition devicePosition;
@property(nonatomic) BOOL isVideoRecording;
@property(nonatomic) BOOL isRotationAllowed;
@property(strong, nonatomic) SSOCameraCaptureHelper *cameraCaptureHelper;
@property(strong, nonatomic) NSMutableArray *arrayImages;
@property(strong, nonatomic) UIImage *libraryImage;

@end

@implementation SSOCameraViewController

#pragma mark - View Controller Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self initializeData];

    // Initialize state of camera to setup UI
    [self initializeStateOfCamera];

    [self showBlurForDuration:0.5];

    // Initialize UI
    // Start with the photo button in the middle
    [self initializeUI];

    [self initAnimatedButton];
    [self initializeAssetsLibrary];

    [self animateCameraRollImageChange];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.animatedCaptureButton.userInteractionEnabled = YES;
    // When recording video and taking a photo, you need to disable interactions with the view. After the recording is finished, you need to re-enable
    // interaction
    self.view.userInteractionEnabled = YES;
    self.flashButton.userInteractionEnabled = YES;
    self.cameraRotationButton.userInteractionEnabled = YES;
    self.mediaButton.userInteractionEnabled = YES;
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

    self.cameraCaptureHelper = [[SSOCameraCaptureHelper alloc] initWithPreviewView:self.cameraPreviewView
                                                                    andOrientation:[UIDevice currentDevice].orientation
                                                                withDevicePosition:self.devicePosition
                                                                    withFlashState:self.flashState];
    self.cameraCaptureHelper.delegate = self;
    //@FIXME
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.inputData = [self populateCellData].mutableCopy;
    [self.collectionView reloadData];
}

/**
 *  The state of the camera is if the flash is on or not, the video is on or not, is the camera rear facing
 */
- (void)initializeStateOfCamera {
    self.flashState = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kFlashState];

    self.torchState = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kTorchState];

    self.devicePosition = [[NSUserDefaults standardUserDefaults] integerForKey:kDevicePosition];
}

/**
 *  InitializeUI
 */
- (void)initializeUI {

    // Allow the user to rotate the screen when the view just appeared
    self.isRotationAllowed = YES;
    self.isVideoRecording = NO;

    // Setup UI for video recording label
    [self initializeFlash];
    [self initializeUICameraDevice];

    [self.view bringSubviewToFront:self.animatedCaptureButton];
}

/**
 *  Update the UI for the camera device depending if it's rear facing or front facing
 */
- (void)initializeUICameraDevice {
    if (self.devicePosition == AVCaptureDevicePositionFront) {
        self.flashButton.hidden = YES;
    } else {
        self.flashButton.hidden = NO;
    }
}

/**
 *  Intialize flash
 */
- (void)initializeFlash {
    if (self.flashState == AVCaptureFlashModeOff) {
        [self.flashButton setImage:[UIImage imageNamed:@"flashButtonIconOFF"] forState:UIControlStateNormal];

    } else if (self.flashState == AVCaptureFlashModeOn) {
        [self.flashButton setImage:[UIImage imageNamed:@"flashButtonIconON"] forState:UIControlStateNormal];

    } else {
        [self.flashButton setImage:[UIImage imageNamed:@"flashButtonIconAUTO"] forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotate {

    return self.isRotationAllowed;
}

/**
 *  Add an animation to the camera roll preview image when we take a picture and come back to camera view
 */
- (void)animateCameraRollImageChange {

    // Check if the libraryImage has been fetched from camera roll. If not call the method again with a small delay (avoid memory bad access)
    if (self.libraryImage) {
        [UIView animateWithDuration:0.3
            animations:^{
              // Fade in
              self.mediaButton.alpha = 0.1;
            }
            completion:^(BOOL finished) {

              [UIView animateWithDuration:0.3
                               animations:^{
                                 [self.mediaButton setImage:self.libraryImage forState:UIControlStateNormal];
                                 // Fade out
                                 self.mediaButton.alpha = 1;
                               }];
            }];
    } else {

        [self performSelector:@selector(animateCameraRollImageChange) withObject:nil afterDelay:0.2];
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
 *  Initialize the camera library and display the last picture in cameraRoll imageView
 */
- (void)initializeAssetsLibrary {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
          usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

            if (group != nil) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];

                [group enumerateAssetsWithOptions:NSEnumerationReverse
                                       usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {

                                         if (asset) {
                                             UIImage *img = [UIImage imageWithCGImage:asset.thumbnail];
                                             self.libraryImage = img;

                                             *stop = YES;
                                         }
                                       }];
            }

            *stop = NO;
          }
          failureBlock:^(NSError *error) {
            NSLog(@"error %@", error);
          }];

    });
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
    WKEditMediaViewController *controller = [WKEditMediaViewController new];
    controller.mediaURL = mediaURL;
    controller.image = image;
    // Push to editMediaVC
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Corner Icons

/**
 *  Update flash button UI
 */
- (void)switchFlashState {
    // Change flash button icon
    if (self.flashState == AVCaptureFlashModeOff) {
        [self.flashButton setImage:[UIImage imageNamed:@"flashButtonIconON"] forState:UIControlStateNormal];

        self.flashState = AVCaptureFlashModeOn;
        self.torchState = AVCaptureTorchModeOn;

    } else if (self.flashState == AVCaptureFlashModeOn) {
        [self.flashButton setImage:[UIImage imageNamed:@"flashButtonIconAUTO"] forState:UIControlStateNormal];
        self.flashState = AVCaptureFlashModeAuto;
        self.torchState = AVCaptureTorchModeAuto;

    } else {
        [self.flashButton setImage:[UIImage imageNamed:@"flashButtonIconOFF"] forState:UIControlStateNormal];
        self.flashState = AVCaptureFlashModeOff;
        self.torchState = AVCaptureTorchModeOff;
    }

    [SSOCameraCaptureHelper setFlashMode:self.flashState forDevice:[[self.cameraCaptureHelper videoDeviceInput] device]];

    [[NSUserDefaults standardUserDefaults] setInteger:self.torchState forKey:kTorchState];
    [[NSUserDefaults standardUserDefaults] setInteger:self.flashState forKey:kFlashState];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  Update rear facing camera button UI
 */
- (void)switchDeviceCameraState {

    [self showBlurForDuration:0.5];
    // Add a flip animation when switching camera
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.cameraPreviewView cache:YES];
    [UIView commitAnimations];

    // Remove flash button
    // Send a message to the photo/video controller to change camera direction
    if (self.devicePosition == AVCaptureDevicePositionFront) {
        self.flashButton.hidden = NO;

        self.devicePosition = AVCaptureDevicePositionBack;

        [self.cameraCaptureHelper changeCameraWithDevicePosition:AVCaptureDevicePositionBack];

    } else {
        self.flashButton.hidden = YES;

        self.devicePosition = AVCaptureDevicePositionFront;

        [self.cameraCaptureHelper changeCameraWithDevicePosition:AVCaptureDevicePositionFront];
    }

    [SSOCameraCaptureHelper setFlashMode:self.flashState forDevice:[[self.cameraCaptureHelper videoDeviceInput] device]];

    [[NSUserDefaults standardUserDefaults] setInteger:self.devicePosition forKey:kDevicePosition];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - IBActions

- (IBAction)cameraDeviceButtonTouched:(id)sender {
    [self switchDeviceCameraState];
}

- (IBAction)mediaButtonTouched:(id)sender {

    // Open a controller that holds the user's photos and videos
    [self displayCamerallRollPickerVC];
}

- (IBAction)flashButtonTouched:(id)sender {

    [self switchFlashState];
}

#pragma mark Capture Button

- (IBAction)captureButtonPushed:(id)sender {

    // Disable user interaction so they can't take more than one photo
    [sender setUserInteractionEnabled:NO];

    [self.cameraCaptureHelper runStillImageCaptureAnimation];

    [self.cameraCaptureHelper snapStillImage];
}

/**
 *  Lock the orientation when the capture button begin to be touched
 *
 *  @param sender the button
 */
- (IBAction)captureButtonTouchedDown:(id)sender {

    [[SSOOrientationHelper sharedInstance] setOrientation:[UIDevice currentDevice].orientation];
}

- (IBAction)profileButtonTouched:(id)sender {
    WKSettingsViewController *settingsVC = [WKSettingsViewController new];
    [self presentViewController:settingsVC animated:YES completion:nil];
}

#pragma mark - Blur

- (void)showBlurForDuration:(double)duration {

    [self showBluredView];
    [self performSelector:@selector(removeBlurredViewWithDuration:) withObject:[NSNumber numberWithDouble:duration] afterDelay:1];
}

- (void)removeBlurredViewWithDuration:(NSNumber *)duration {

    [UIView animateWithDuration:[duration doubleValue]
        animations:^{
          self.effectView.alpha = 0;
        }
        completion:^(BOOL finished) {
          [self.effectView removeFromSuperview];
          self.effectView = nil;

        }];
}

- (void)showBluredView {
    self.blurEffectview = [[UIView alloc] initWithFrame:self.view.bounds];
    self.blurEffectview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    // self.blurEffectview.alpha = 0.9;
    self.blurEffectview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    // create blur effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    // create vibrancy effect
    // UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];

    // add blur to an effect view
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];

    self.effectView.frame = self.view.frame;

    // add vibrancy to yet another effect view
    // UIVisualEffectView* vibrantView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
    // effectView.frame = CGRectMake(0, 0, self.sizeOfView.width, self.sizeOfView.height);

    [self.effectView.contentView addSubview:self.blurEffectview];

    // add both effect views to the image view
    [self.cameraPreviewView addSubview:self.effectView];
    // [self addSubview:vibrantView];

    [self.effectView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
}

#pragma mark - SSORoundedAnimatedButtonProtocol

- (void)didStartLongPressGesture:(SSORoundedAnimatedButton *)button {

    // Enable torch state when recording video
    [SSOCameraCaptureHelper setTorchMode:self.torchState forDevice:[[self.cameraCaptureHelper videoDeviceInput] device]];

    // Disable interaction with flash and other corner icons
    self.flashButton.userInteractionEnabled = NO;
    self.cameraRotationButton.userInteractionEnabled = NO;
    self.mediaButton.userInteractionEnabled = NO;

    [self.cameraCaptureHelper toggleMovieRecording];
    self.isRotationAllowed = NO;
    self.isVideoRecording = YES;
}

- (void)didFinishLongPressGesture:(SSORoundedAnimatedButton *)button {
    [button setUserInteractionEnabled:NO];

    [SSOCameraCaptureHelper setTorchMode:AVCaptureTorchModeOff forDevice:[[self.cameraCaptureHelper videoDeviceInput] device]];

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
        WKEditMediaViewController *controller = [WKEditMediaViewController new];
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

#pragma mark - BaseCollectionView

/**
 *  This method is just used to generate the table view data for the SSBaseCollectionView.
 *
 *  @param inputArray Takes as input an organized array of Adjicons
 *
 *  @return Returns an array of arrays with sections containing elements
 */

- (NSArray *)populateCellData {

    NSMutableArray *cellDataArray = [NSMutableArray new];

    SSCellViewSection *section = [[SSCellViewSection alloc] init];

    for (UIImage *image in self.arrayImages) {
        SSCellViewItem *newElement;

        newElement = [SSCellViewItem new];
        newElement.cellReusableIdentifier = @"collectionCell";
        newElement.objectData = image;
        [section.rows addObject:newElement];
    }

    [cellDataArray addObject:section];

    return cellDataArray;
}

//@TODO
- (NSMutableArray *)arrayImages {

    if (!_arrayImages) {
        _arrayImages = [[NSMutableArray alloc] init];
    }

    _arrayImages = @[
        [UIImage imageNamed:@"Alien"],
        [UIImage imageNamed:@"hankey"],
        [UIImage imageNamed:@"Unknown"],
        [UIImage imageNamed:@"Alien"],
        [UIImage imageNamed:@"hankey"],
        [UIImage imageNamed:@"Unknown"],
        [UIImage imageNamed:@"Alien"],
        [UIImage imageNamed:@"hankey"],
        [UIImage imageNamed:@"Unknown"]
    ].mutableCopy;
    //[_arrayImages arrayByAddingObjectsFromArray:_arrayImages];
    return _arrayImages;
}

@end
