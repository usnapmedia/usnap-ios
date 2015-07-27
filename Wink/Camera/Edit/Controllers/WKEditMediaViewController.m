//
//  WKEditImageViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKEditMediaViewController.h"
#import "SSOEditToolController.h"
#import "SSODrawToolController.h"
#import "SSOTextToolController.h"
#import "SSOAdjustmentToolController.h"
#import "SSOSubtoolContainerView.h"
#import "SSOButtonsContainerView.h"
#import "SSOAccessoryContainerView.h"
#import "SSOFadingContainerView.h"
#import "SSOToolButton.h"

#import "UINavigationController+SSOLockedNavigationController.h"

#import "SSCellViewItem.h"
#import "SSCellViewSection.h"

#import <Masonry.h>
#import "SSOEditSideMenuView.h"
#import "SSOLoginViewController.h"
#import "SSSessionManager.h"
#import "SSOOrientationHelper.h"
#import <RSKImageCropViewController.h>

@interface WKEditMediaViewController () <UITextViewDelegate, WKMoviePlayerDelegate, SSOLoginRegisterDelegate, SSOEditToolDelegate,
                                         RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

// UI
@property(weak, nonatomic) IBOutlet UIButton *postButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet SSOEditSideMenuView *sideMenuView;
@property(weak, nonatomic) IBOutlet UIView *overlayView;
// Containers
@property(weak, nonatomic) IBOutlet SSOFadingContainerView *topView;
@property(strong, nonatomic) SSOSubtoolContainerView *subtoolContainerView;
@property(strong, nonatomic) SSOAccessoryContainerView *accessoryContainerView;
@property(strong, nonatomic) SSOButtonsContainerView *buttonsContainerView;
// Tools
@property(nonatomic, strong) ACEDrawingView *drawView;
@property(nonatomic, strong) SSOEditMediaMovableTextView *textView;
@property(nonatomic, strong) SSOAdjustementsHelper *adjustementHelper;
// Media
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *modifiedImageView;
@property(nonatomic, strong) WKMoviePlayerView *moviePlayerView;

@property(strong, nonatomic) SSOEditToolController *childViewController;
@property(strong, nonatomic) NSArray *buttonsToSwitch;

@end

@implementation WKEditMediaViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup UI
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceChangedOrientation:) name:kDeviceOrientationNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupEditButtons];
    [self deviceChangedOrientation:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Play the movie player
    [self.moviePlayerView.player play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // Stop the movie player
    [self.moviePlayerView.player pause];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Remove the keyboard
    [self.textView resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Orientation

/**
 *  Block the screen rotation
 *
 *  @return BOOL
 */
- (BOOL)shouldAutorotate {

    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIDeviceOrientationPortrait;
    // return [[SSOOrientationHelper sharedInstance] orientation];
}

- (void)deviceChangedOrientation:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
    case UIDeviceOrientationPortrait: {
        [self rotateButtons:0];
        break;
    }

    case UIDeviceOrientationLandscapeLeft: {
        [self rotateButtons:M_PI_2];
        break;
    }
    case UIDeviceOrientationLandscapeRight: {
        [self rotateButtons:-M_PI_2];
        break;
    }
    default: { break; }
    }
}

- (void)rotateButtons:(CGFloat)rotation {
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       for (UIView *viewToRotate in self.buttonsToSwitch) {
                           viewToRotate.transform = CGAffineTransformMakeRotation(rotation);
                       }
                     }
                     completion:nil];
}

/**
 *  Detect if the phone is being rotated and return the new  size of the screen
 *
 *  @param size        the size of  the screen
 *  @param coordinator transition coordinator
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    CGSize sizeMinusCollectionView = CGSizeMake(size.width, size.height - self.feedContainerView.frame.size.height);

    [self.sideMenuView setSizeOfView:sizeMinusCollectionView];
}

#pragma mark - Initialization

- (void)setUI {

    // Setup the imageview
    if (self.image) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.overlayView.frame.origin.x, self.self.overlayView.frame.origin.y,
                                                                       self.overlayView.frame.size.width, self.overlayView.frame.size.height)];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = self.image;
        [self.view insertSubview:self.imageView atIndex:0];
    }
    // Setup the movie player view
    else {
        self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:self.mediaURL];
        self.moviePlayerView.delegate = self;
        self.moviePlayerView.frame = self.overlayView.bounds;
        self.moviePlayerView.contentMode = UIViewContentModeScaleAspectFill;
        self.moviePlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.moviePlayerView.clipsToBounds = YES;
        // Force a black background here
        self.moviePlayerView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:self.moviePlayerView atIndex:0];
    }

    // Make the top container top constraint on the bottom of the feed controller.
    // Feed controller comes from the base class
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.feedContainerView.mas_bottom);
    }];
}

/**
 *  Setup the edit buttons
 */
- (void)setupEditButtons {
    //@TODO This should be generic
    UIButton *drawButton = [UIButton new];
    [drawButton setImage:[UIImage imageNamed:@"ic_brush"] forState:UIControlStateNormal];
    [drawButton addTarget:self action:@selector(drawButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *textButton = [UIButton new];
    [textButton setImage:[UIImage imageNamed:@"ic_text"] forState:UIControlStateNormal];
    [textButton addTarget:self action:@selector(textButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    if (self.imageView.image) {
        UIButton *adjustmentButton = [UIButton new];
        [adjustmentButton setImage:[UIImage imageNamed:@"ic_brightness"] forState:UIControlStateNormal];
        [adjustmentButton addTarget:self action:@selector(adjustmentButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *cropButton = [UIButton new];
        [cropButton setImage:[UIImage imageNamed:@"ic_crop"] forState:UIControlStateNormal];
        [cropButton addTarget:self action:@selector(cropButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

        self.buttonsToSwitch = @[ drawButton, textButton, adjustmentButton, cropButton ];

        // Set the array of buttons for the side menu
        self.sideMenuView.arrayButtons = @[ drawButton, textButton, adjustmentButton, cropButton ];
    } else {
        self.buttonsToSwitch = @[ drawButton, textButton ];

        // Set the array of buttons for the side menu
        self.sideMenuView.arrayButtons = @[ drawButton, textButton ];
    }
    [self.sideMenuView setSizeOfView:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.feedContainerView.frame.size.height)];
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    // Send touch to the child VC
    [self.childViewController touchesBegan:touches withEvent:event];
}

#pragma mark - Child View Controller

- (void)animateToChildViewController:(SSOEditToolController *)newVC {
    // Set child VC
    self.childViewController = newVC;
    // Add the child vc
    [self addChildViewController:newVC];
    // Set the frame
    newVC.view.frame = self.view.frame;
    //    // Add subview
    //    [self.view addSubview:newVC.view];
    // Call delegate
    [newVC didMoveToParentViewController:self];
}

- (void)removeChildViewController {
    [self.childViewController willMoveToParentViewController:nil];
    [self.childViewController.view removeFromSuperview];
    [self.childViewController removeFromParentViewController];
    self.childViewController = nil;
}

#pragma mark - Movie View Methods

- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer {
    [self.moviePlayerView.player play];
}

#pragma mark - Button Actions

- (void)drawButtonTouched:(id)sender {
    SSODrawToolController *childVC = [SSODrawToolController new];

    [self.overlayView bringSubviewToFront:self.drawView];

    childVC.delegate = self;
    [self animateToChildViewController:childVC];
}

- (void)textButtonTouched:(id)sender {
    // Set the next state for the media edit
    SSOTextToolController *childVC = [SSOTextToolController new];
    childVC.delegate = self;
    [self animateToChildViewController:childVC];
    [self.overlayView bringSubviewToFront:self.textView];
    if ([self.textView.text isEqualToString:@""]) {
        [self.textView setFrame:CGRectMake(0.0f, self.overlayView.frame.size.height / 2 - 45.0f, self.overlayView.frame.size.width, 70.0f)];
    }
}

- (void)adjustmentButtonTouched:(id)sender {
    SSOAdjustmentToolController *childVC = [SSOAdjustmentToolController new];
    childVC.delegate = self;
    self.adjustementHelper.imageToEdit = self.image;
    self.adjustementHelper.imageViewToEdit = self.imageView;
    [self animateToChildViewController:childVC];
}

- (void)cropButtonTouched:(id)sender {
    RSKImageCropViewController *cropperVC = [[RSKImageCropViewController alloc] initWithImage:self.imageView.image];
    cropperVC.delegate = self;
    [cropperVC.cancelButton setTitle:NSLocalizedString(@"crop_cancel_button", nil) forState:UIControlStateNormal];
    [cropperVC.chooseButton setTitle:NSLocalizedString(@"crop_done_button", nil) forState:UIControlStateNormal];
    [cropperVC.moveAndScaleLabel setText:NSLocalizedString(@"crop_title", nil)];
    cropperVC.cropMode = RSKImageCropModeCustom;
    cropperVC.dataSource = self;
    [self presentViewController:cropperVC animated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)postButtonTouched:(id)sender {
    if ([[SSSessionManager sharedInstance] isUserLoggedIn]) {
        [self pushToShareVC];
    } else {
        [self presentLoginVC];
    }
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)pushToShareVC {
    WKShareViewController *controller = [WKShareViewController new];
    controller.image = [self.imageView snapshotImage];
    controller.mediaURL = self.mediaURL;
    if (self.modifiedImageView.image) {
        controller.modifiedImage = [self.modifiedImageView snapshotImage];
    } else {
        //    if (self.image) {
        controller.overlayImage = [self.overlayView snapshotImage];
    }
    //    } else {
    //
    //        // Scale the overlay image to the same size as the video while keeping the aspect ratio
    //        UIImage *overlayImage = [self.overlayView snapshotImage];
    //        CGSize videoSize = self.moviePlayerView.videoSize;
    //
    //        // Get appropriate scale factor
    //        CGFloat videoRatio = videoSize.width / videoSize.height;
    //        CGFloat overlayRatio = overlayImage.size.width / overlayImage.size.height;
    //        CGFloat scaleFactor = videoSize.height / overlayImage.size.height;
    //        if (overlayRatio > videoRatio) {
    //            scaleFactor = videoSize.width / overlayImage.size.width;
    //        }
    //
    //        // Scale the width and height of the overlay
    //        CGFloat newWidth = floorf(overlayImage.size.width * scaleFactor);
    //        if ((int)newWidth % 2 != 0) {
    //            newWidth -= 1;
    //        }
    //        CGFloat newHeight = floorf(overlayImage.size.height * scaleFactor);
    //        if ((int)newHeight % 2 != 0) {
    //            newHeight -= 1;
    //        }
    //
    //        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 1.0f);
    //        [overlayImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    //        controller.overlayImage = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentLoginVC {
    SSOLoginViewController *loginVC = [SSOLoginViewController new];
    loginVC.delegate = self;
    // Present VC
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - SSOEditToolDelegate

- (void)editToolWillEndEditing:(SSOEditToolController *)tool {
    // Remove the VC
    [self removeChildViewController];
}

- (void)editToolWillBeginEditing:(SSOEditToolController *)tool {
    // Remove all the subviews before displaying the new one
    [self.accessoryContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subtoolContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - RSKImageCropViewControllerDelegate

/**
 *  RSKImageCropViewControllerDelegate action when pressing back button
 *
 *  @param controller the RSKImageCropViewController
 */
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  RSKImageCropViewControllerDelegate action when pressing confirm button to crop the image
 *
 *  @param controller the RSKImageCropViewController
 *  @param croppedImage the returned cropped image
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
                                     self.image = croppedImage;
                                     self.imageView.image = croppedImage;
                                     self.modifiedImageView.image = croppedImage;
                                   }];
}

#pragma mark - RSKImageCropViewControllerDataSourceDelegate

/**
 *  Asks the data source a custom rect for the mask.
 *
 *  @param CGRect controller The crop view controller object to whom a rect is provided.
 *
 *  @return A custom rect for the mask.
 */

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    // This is to get the maximum size of the mask. It will be always less than 75% of the view
    CGFloat witdh = self.imageView.image.size.width;
    CGFloat height = self.imageView.image.size.height;
    CGFloat maxWitdh = self.imageView.frame.size.width * 0.75;
    CGFloat maxHeight = self.imageView.frame.size.height * 0.75;
    do {
        witdh = witdh / 2;
        height = height / 2;
    } while (witdh > maxWitdh && height > maxHeight);
    CGSize maskSize = CGSizeMake(witdh, height);
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    // The image will always have the same aspect of the photo
    return CGRectMake((viewWidth - maskSize.width) * 0.5f, (viewHeight - maskSize.height) * 0.5f, maskSize.width, maskSize.height);
}

/**
 *  Asks the data source a custom path for the mask.
 *
 *  @param controller controller The crop view controller object to whom a path is provided.
 *
 *  @return A custom path for the mask.
 */

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    CGRect rect = controller.maskRect;
    // All the points of the image
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    // Drawing the image
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path closePath];
    return path;
}

#pragma mark - SSOEditViewControllerProtocol

#pragma mark Tools view

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (ACEDrawingView *)drawView {
    if (!_drawView) {
        // Setup view
        _drawView = [[ACEDrawingView alloc] initWithFrame:self.overlayView.frame];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.lineWidth = 4.0f;

        // Insert view
        [self.overlayView insertSubview:_drawView belowSubview:self.textView];

        // Set constraints
        [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.overlayView);
        }];
    }
    return _drawView;
}

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (SSOEditMediaMovableTextView *)textView {
    if (!_textView) {
        // Setup the text view
        _textView = [[SSOEditMediaMovableTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.overlayView.frame.size.width, 70.0f)];
        [self.overlayView addSubview:_textView];
    }
    return _textView;
}

- (UIImageView *)imageView {
    return _imageView;
}

- (SSOAdjustementsHelper *)adjustmentHelper {
    if (!_adjustementHelper) {
        // Setup the text view
        _adjustementHelper = [SSOAdjustementsHelper new];
        _adjustementHelper.imageToEdit = self.image;
        _adjustementHelper.imageViewToEdit = self.imageView;
    }
    return _adjustementHelper;
}

#pragma mark Container view

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (UIView *)subtoolContainerView {
    if (!_subtoolContainerView) {
        // Initialize the view with the bottom view size. We also need to push it at the bottom of the view completely as it's initial position for the
        // scroll
        // effect.
        //@FIXME Orientation will be problematic
        _subtoolContainerView =
            [[SSOSubtoolContainerView alloc] initWithFrame:CGRectMake(self.sideMenuView.frame.origin.x, self.view.frame.size.height,
                                                                      self.sideMenuView.frame.size.width, self.sideMenuView.frame.size.height)];
        // Add the view
        [self.view addSubview:_subtoolContainerView];
    }

    return _subtoolContainerView;
}

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (UIView *)accessoryContainerView {
    if (!_accessoryContainerView) {
        // Initialize as big as the bottom view
        _accessoryContainerView = [[SSOAccessoryContainerView alloc] initWithFrame:self.sideMenuView.frame];
        // Add the view
        [self.view addSubview:_accessoryContainerView];
    }

    return _accessoryContainerView;
}

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (UIView *)buttonsContainerView {
    if (!_buttonsContainerView) {
        // Initialize as big as the top view
        _buttonsContainerView = [[SSOButtonsContainerView alloc] initWithFrame:self.topView.frame];
        // Hide and add the view
        _buttonsContainerView.hidden = YES;
        [self.view addSubview:_buttonsContainerView];
    }

    return _buttonsContainerView;
}

/**
 *  Get the bottom container view
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)bottomView {
    return _sideMenuView;
}

/**
 *  Get the top container view
 *
 *  @return the view
 */
- (UIView<SSOAnimatableView> *)topView {
    return _topView;
}

#pragma mark - SSOLoginRegisterDelegate

/**
 *  Called when the loginVC is dismissed
 */
- (void)didFinishAuthProcess {
    WKShareViewController *controller = [[WKShareViewController alloc] initWithNibName:@"WKShareViewController" bundle:nil];
    controller.image = [self.imageView snapshotImage];
    controller.mediaURL = self.mediaURL;
    if (self.modifiedImageView.image) {
        controller.modifiedImage = [self.modifiedImageView snapshotImage];
    }
    if (self.image) {
        controller.overlayImage = [self.overlayView snapshotImage];
    }

    [self.navigationController pushViewController:controller animated:YES];
}

@end
