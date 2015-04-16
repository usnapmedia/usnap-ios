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

#import "UINavigationController+SSOLockedNavigationController.h"

#import "SSCellViewItem.h"
#import "SSCellViewSection.h"

#import <Masonry.h>
#import "SSOEditSideMenuView.h"
#import "SSOLoginViewController.h"
#import "SSSessionManager.h"
#import "NSUserDefaults+USnap.h"
#import "WKNavigationController.h"

@interface WKEditMediaViewController () <UITextViewDelegate, WKMoviePlayerDelegate, SSOLoginRegisterDelegate, SSOEditToolDelegate,
                                         RSKImageCropViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *watermarkImageView;
@property(weak, nonatomic) IBOutlet UIButton *postButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet SSOEditSideMenuView *sideMenuView;

@property(nonatomic, strong) NSMutableArray *arrayImages;

@property(strong, nonatomic) SSOEditToolController *childViewController;

// Containers
@property(weak, nonatomic) IBOutlet SSOFadingContainerView *bottomView;
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

@end

@implementation WKEditMediaViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.sideMenuView setSizeOfView:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.collectionView.frame.size.height)];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Remove the keyboard
    [self.textView resignFirstResponder];
}

/**
 *  Detect if the phone is being rotated and return the new  size of the screen
 *
 *  @param size        the size of  the screen
 *  @param coordinator transition coordinator
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    CGSize sizeMinusCollectionView = CGSizeMake(size.width, size.height - self.collectionView.frame.size.height);

    [self.sideMenuView setSizeOfView:sizeMinusCollectionView];
}

- (void)setUI {

    // Setup the imageview
    if (self.image) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = self.image;
        [self.view insertSubview:self.imageView atIndex:0];
    }
    // Setup the movie player view
    else {
        self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:self.mediaURL];
        self.moviePlayerView.delegate = self;
        self.moviePlayerView.frame = self.view.bounds;
        self.moviePlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.moviePlayerView.clipsToBounds = YES;
        [self.view insertSubview:self.moviePlayerView atIndex:0];
    }

    // Remove brightness and crop options for media and re-position draw and text
    if (self.mediaURL) {
        self.brightnessButton.hidden = YES;
        self.cropButton.hidden = YES;
    }

    //@FIXME
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.inputData = [self populateCellData].mutableCopy;
    [self.collectionView reloadData];
}

#pragma mark - Getter

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

- (IBAction)drawButtonTouched:(id)sender {
    SSODrawToolController *childVC = [SSODrawToolController new];
    childVC.delegate = self;
    [self animateToChildViewController:childVC];
}

- (IBAction)textButtonTouched:(id)sender {
    // Set the next state for the media edit
    SSOTextToolController *childVC = [SSOTextToolController new];
    childVC.delegate = self;
    [self animateToChildViewController:childVC];
}

- (IBAction)adjustmentButtonTouched:(id)sender {
    SSOAdjustmentToolController *childVC = [SSOAdjustmentToolController new];
    childVC.delegate = self;
    [self animateToChildViewController:childVC];
}

- (IBAction)cropButtonTouched:(id)sender {
    RSKImageCropViewController *cropperVC = [[RSKImageCropViewController alloc] initWithImage:self.imageView.image];
    cropperVC.delegate = self;
    [cropperVC.cancelButton setTitle:NSLocalizedString(@"crop_cancel_button", nil) forState:UIControlStateNormal];
    [cropperVC.chooseButton setTitle:NSLocalizedString(@"crop_done_button", nil) forState:UIControlStateNormal];
    [cropperVC.moveAndScaleLabel setText:NSLocalizedString(@"crop_title", nil)];
    // Set the crop rectangle to the image view
    cropperVC.cropMode = RSKImageCropModeSquare;
    [self presentViewController:cropperVC animated:YES completion:nil];
}

- (IBAction)postButtonTouched:(id)sender {
    WKShareViewController *controller = [[WKShareViewController alloc] initWithNibName:@"WKShareViewController" bundle:nil];
    controller.image = [self.imageView snapshotImage];
    controller.mediaURL = self.mediaURL;
    if (self.modifiedImageView.image) {
        controller.modifiedImage = [self.modifiedImageView snapshotImage];
    }
    if (self.image) {
        controller.overlayImage = [self.overlayView snapshotImage];
    } else {

        // Scale the overlay image to the same size as the video while keeping the aspect ratio
        UIImage *overlayImage = [self.overlayView snapshotImage];
        CGSize videoSize = self.moviePlayerView.videoSize;

        // Get appropriate scale factor
        CGFloat videoRatio = videoSize.width / videoSize.height;
        CGFloat overlayRatio = overlayImage.size.width / overlayImage.size.height;
        CGFloat scaleFactor = videoSize.height / overlayImage.size.height;
        if (overlayRatio > videoRatio) {
            scaleFactor = videoSize.width / overlayImage.size.width;
        }

        // Scale the width and height of the overlay
        CGFloat newWidth = floorf(overlayImage.size.width * scaleFactor);
        if ((int)newWidth % 2 != 0) {
            newWidth -= 1;
        }
        CGFloat newHeight = floorf(overlayImage.size.height * scaleFactor);
        if ((int)newHeight % 2 != 0) {
            newHeight -= 1;
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 1.0f);
        [overlayImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        controller.overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
                                     self.imageView.image = croppedImage;
                                   }];
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
        _drawView = [[ACEDrawingView alloc] initWithFrame:self.view.frame];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.lineWidth = 4.0f;

        // Insert view
        [self.overlayView insertSubview:_drawView belowSubview:self.textView];

        // Set constraints
        [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.view);
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
        [self.overlayView insertSubview:_textView belowSubview:self.watermarkImageView];
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
        // Initialize the view with the bottom view size. We also need to push it at the bottom of the view completely as it's initial position for the scroll
        // effect.
        //@FIXME Orientation will be problematic
        _subtoolContainerView = [[SSOSubtoolContainerView alloc] initWithFrame:CGRectMake(self.bottomView.frame.origin.x, self.view.frame.size.height,
                                                                                          self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
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
        _accessoryContainerView = [[SSOAccessoryContainerView alloc] initWithFrame:self.bottomView.frame];
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
    return _bottomView;
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
