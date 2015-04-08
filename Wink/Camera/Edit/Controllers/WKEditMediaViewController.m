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
#import "SSOSubtoolContainerView.h"
#import "SSOBottomContainerView.h"
#import "SSOMediaEditState.h"
#import "SSOMediaEditStateCrop.h"
#import "SSOMediaEditStateNone.h"
#import "SSOMediaEditStateText.h"
#import "SSOMediaEditStateDrawGray.h"
#import "SSOMediaEditStateDrawColor.h"
#import "SSOMediaEditStateBrightness.h"

#import "SSCellViewItem.h"
#import "SSCellViewSection.h"

#import <Masonry.h>
#import <pop/POP.h>

@interface WKEditMediaViewController () <UITextViewDelegate, WKMoviePlayerDelegate>

@property(nonatomic, strong) SSOMediaEditState *mediaEditState;
@property(weak, nonatomic) IBOutlet UIImageView *watermarkImageView;
@property(weak, nonatomic) IBOutlet UIButton *postButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;

@property(nonatomic, strong) NSMutableArray *arrayImages;

@property(strong, nonatomic) SSOEditToolController *childViewController;

// Containers
@property(weak, nonatomic) IBOutlet SSOBottomContainerView *bottomView;
@property(weak, nonatomic) IBOutlet UIView *topView;
@property(strong, nonatomic) SSOSubtoolContainerView *subtoolContainerView;
@property(strong, nonatomic) UIView *accessoryContainerView;
@property(strong, nonatomic) UIView *buttonsContainerView;

// Tools
@property(nonatomic, strong) ACEDrawingView *drawView;
@property(nonatomic, strong) SSOEditMediaMovableTextView *textView;

// Media
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *modifiedImageView;
@property(nonatomic, strong) WKMoviePlayerView *moviePlayerView;

@end

@implementation WKEditMediaViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mediaEditState = [SSOMediaEditStateNone new];

    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Reset the state to none
    self.mediaEditState = [SSOMediaEditStateNone new];
    [(SSOMediaEditStateNone *)self.mediaEditState resetButtonsState];
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
    // Remove the keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Remove the keyboard
    [self.textView resignFirstResponder];
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

#pragma mark - Setter

- (void)setMediaEditState:(SSOMediaEditState *)mediaEditState {
    _mediaEditState = mediaEditState;
    // Set the VC for the state object
    [_mediaEditState setEditMediaVC:self];
}

#pragma mark - Keyboard Methods

- (void)keyboardWillHide {
    // Set the type to none and reset the button
    self.mediaEditState = [SSOMediaEditStateNone new];
    [(SSOMediaEditStateNone *)self.mediaEditState resetButtonsState];
}

#pragma mark - Touch Methods

//@FIXME
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    // We have to check since the method is optional
    if ([self.mediaEditState respondsToSelector:@selector(touchesBegan:withEvent:)]) {
        [self.mediaEditState touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    // We have to check since the method is optional
    if ([self.mediaEditState respondsToSelector:@selector(touchesMoved:withEvent:)]) {
        [self.mediaEditState touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    // We have to check since the method is optional
    if ([self.mediaEditState respondsToSelector:@selector(touchesEnded:withEvent:)]) {
        [self.mediaEditState touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    // We have to check since the method is optional
    if ([self.mediaEditState respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
        [self.mediaEditState touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - Child View Controller

- (void)animateToChildViewController:(SSOEditToolController *)newVC {
    if (self.childViewController) {

        [self.childViewController willMoveToParentViewController:nil]; // 1
        [self addChildViewController:newVC];
        newVC.view.frame = self.view.frame;

        [self transitionFromViewController:self.childViewController
            toViewController:newVC
            duration:0.5
            options:0
            animations:^{
              if ([self.childViewController respondsToSelector:@selector(hideContainerViews:)]) {
                  [self.childViewController hideContainerViews:YES];
              }
            }
            completion:^(BOOL finished) {
              [self.childViewController removeFromParentViewController];
              self.childViewController = newVC;
              if ([self.childViewController respondsToSelector:@selector(displayContainerViews:)]) {
                  [self.childViewController displayContainerViews:YES];
              }
              [self.childViewController didMoveToParentViewController:self];
            }];
    } else {
        self.childViewController = newVC;
        [self addChildViewController:self.childViewController];
        self.childViewController.view.frame = self.view.frame;
        if ([self.childViewController respondsToSelector:@selector(displayContainerViews:)]) {
            [self.childViewController displayContainerViews:YES];
        }
        [self.childViewController didMoveToParentViewController:self];
    }
}

#pragma mark - Movie View Methods

- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer {
    [self.moviePlayerView.player play];
}

#pragma mark - Button Actions

- (IBAction)drawButtonTouched:(id)sender {
    SSODrawToolController *childVC = [SSODrawToolController new];
    [self animateToChildViewController:childVC];
}

- (IBAction)textButtonTouched:(id)sender {
    // Set the next state for the media edit
    if ([self.mediaEditState state] == SSOMediaEditStateEnumText) {
        self.mediaEditState = [SSOMediaEditStateNone new];
    } else {
        self.mediaEditState = [SSOMediaEditStateText new];
    }
    [self.mediaEditState textButtonTouched];
}

- (IBAction)brightnessButtonTouched:(id)sender {
    // Set the next state for the media edit
    if ([self.mediaEditState state] == SSOMediaEditStateEnumBrightness) {
        self.mediaEditState = [SSOMediaEditStateNone new];
    } else {
        self.mediaEditState = [SSOMediaEditStateBrightness new];
    }
    [self.mediaEditState brightnessButtonTouched];
}

- (IBAction)cropButtonTouched:(id)sender {
    // Set the next state for the media edit
    if ([self.mediaEditState state] == SSOMediaEditStateEnumCrop) {
        self.mediaEditState = [SSOMediaEditStateNone new];
    } else {
        self.mediaEditState = [SSOMediaEditStateCrop new];
    }
    [self.mediaEditState cropButtonTouched];
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

#pragma mark Container view

/**
 *  Lazy instanciation
 *
 *  @return the view
 */
- (UIView *)subtoolContainerView {
    if (!_subtoolContainerView) {
        // Initialize as big as the bottom view
        _subtoolContainerView = [[SSOSubtoolContainerView alloc] initWithFrame:self.bottomView.frame];
        // Hide and add the view
        _subtoolContainerView.hidden = YES;
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
        _accessoryContainerView = [[UIView alloc] initWithFrame:self.bottomView.frame];
        // Hide and add the view
        _accessoryContainerView.hidden = YES;
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
        _buttonsContainerView = [[UIView alloc] initWithFrame:self.topView.frame];
        // Hide and add the view
        _buttonsContainerView.hidden = YES;
        [self.view addSubview:_buttonsContainerView];
    }

    return _buttonsContainerView;
}

- (UIView<SSOAnimatableView> *)bottomView {
    return _bottomView;
}

- (UIView<SSOAnimatableView> *)topView {
    return _topView;
}
@end
