//
//  WKEditImageViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKEditMediaViewController.h"
#import "SSOMediaEditState.h"
#import "SSOMediaEditStateCrop.h"
#import "SSOMediaEditStateNone.h"
#import "SSOMediaEditStateText.h"
#import "SSOMediaEditStateDrawGray.h"
#import "SSOMediaEditStateDrawColor.h"
#import "SSOMediaEditStateBrightness.h"

@interface WKEditMediaViewController () <UITextViewDelegate, WKMoviePlayerDelegate, ACEDrawingViewDelegate>

@property(nonatomic, strong) SSOMediaEditState *mediaEditState;

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
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = self.image;
        [self.view insertSubview:self.imageView atIndex:0];

        //                self.modifiedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        //                self.modifiedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //                self.modifiedImageView.contentMode = UIViewContentModeScaleAspectFill;
        //                self.modifiedImageView.clipsToBounds = YES;
        //                self.modifiedImageView.image = self.image;
        //                [self.view insertSubview:self.modifiedImageView atIndex:1];
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

    // Setup the draw view
    self.drawView = [[ACEDrawingView alloc] initWithFrame:self.view.bounds];
    self.drawView.delegate = self;
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.drawView.backgroundColor = [UIColor clearColor];
    self.drawView.lineWidth = 4.0f;
    [self.overlayView insertSubview:self.drawView belowSubview:self.watermarkImageView];

    // Setup the draw container view
    self.drawContainerView.backgroundColor = [UIColor clearColor];

    // Setup the colors for the color picker
    self.colorPickerColors =
        [NSArray arrayWithObjects:[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor redColor], nil];
    self.colorPickerGrayscaleColors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], nil];

    // Setup the text view
    self.textView = [[SSOEditMediaMovableTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.overlayView.frame.size.width, 70.0f)];
    self.textView.delegate = self;
    [self.overlayView insertSubview:self.textView belowSubview:self.watermarkImageView];

   // [self initBrightnessAndContrastUI];
}


-(void)viewWillAppear:(BOOL)animated {
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

#pragma mark - Setter

- (void)setMediaEditState:(SSOMediaEditState *)mediaEditState {
    _mediaEditState = mediaEditState;
    // Set the VC for the state object
    [_mediaEditState setEditMediaVC:self];
}

#pragma mark - Keyboard Methods

- (void)keyboardWillHide {
    self.mediaEditState = [SSOMediaEditStateNone new];
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    CGPoint point = [touches.anyObject locationInView:self.textView];
    if (CGRectContainsPoint(self.textView.bounds, point) && self.textView.text.length > 0 && self.editType == WKEditMediaViewControllerEditTypeNone) {
        self.movingTextView = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (self.movingTextView) {
        CGPoint point = [touches.anyObject locationInView:self.overlayView];
        self.textView.center = point;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    self.movingTextView = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    self.movingTextView = NO;
}

#pragma mark - Draw View Methods

- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool {
    //    [self updateUI];
}

#pragma mark - Movie View Methods

- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer {
    [self.moviePlayerView.player play];
}

#pragma mark - Textview Methods

- (void)textViewDidChange:(UITextView *)textView {

    CGPoint center = textView.center;
    CGSize size = [textView sizeThatFits:textView.superview.bounds.size];
    textView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    textView.center = center;

    NSRange range = [textView.text rangeOfString:@"\n"];
    if (range.location != NSNotFound) {
        textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@""];
        self.editType = WKEditMediaViewControllerEditTypeNone;
    }
}

#pragma mark - Crop Image

- (void)cropImage {
    // self.modifiedImageView.image = self.imageCropperView.croppedImage;
}

#pragma mark - Button Actions

- (IBAction)selectedColorChanged:(id)sender {
    //    [self updateUI];
}

- (IBAction)undoButtonTouched:(id)sender {
    [self.drawView undoLatestStep];

    //    [self updateUI];
}

- (IBAction)drawButtonTouched:(id)sender {
    // Set the next state for the media edit
    if ([self.mediaEditState state] == SSOMediaEditStateEnumDrawGray) {
        self.mediaEditState = [SSOMediaEditStateNone new];
    } else if ([self.mediaEditState state] == SSOMediaEditStateEnumDrawColor) {
        self.mediaEditState = [SSOMediaEditStateDrawGray new];
    } else {
        self.mediaEditState = [SSOMediaEditStateDrawColor new];
    }

    [self.mediaEditState drawButtonTouched];
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


    //
    //    WKEditMediaViewControllerEditType type = WKEditMediaViewControllerEditTypeCrop;
    //    if (self.editType == WKEditMediaViewControllerEditTypeCrop) {
    //        type = WKEditMediaViewControllerEditTypeNone;
    //    }
    //    self.editType = type;
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



@end
