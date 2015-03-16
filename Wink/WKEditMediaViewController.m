//
//  WKEditImageViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKEditMediaViewController.h"
#import "ACEDrawingView.h"
#import "WKMoviePlayerView.h"
#import "WKShareViewController.h"
#import "WKColorPickerView.h"
#import "YKImageCropperView.h"
#import <PECropView.h>
#import <Masonry.h>
#import "SSOEditMediaMovableTextView.h"

#import "BrightnessContrastSlidersView.h"
#import "SSOBrightnessContrastHelper.h"

typedef enum {
    WKEditMediaViewControllerEditTypeNone,
    WKEditMediaViewControllerEditTypeDrawColor,
    WKEditMediaViewControllerEditTypeDrawGrayscale,
    WKEditMediaViewControllerEditTypeText,
    WKEditMediaViewControllerEditTypeBrightness,
    WKEditMediaViewControllerEditTypeCrop
} WKEditMediaViewControllerEditType;

@interface WKEditMediaViewController () <UITextViewDelegate, WKMoviePlayerDelegate, ACEDrawingViewDelegate>
@property(nonatomic) WKEditMediaViewControllerEditType editType;

// Media
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *modifiedImageView;
@property(nonatomic, strong) WKMoviePlayerView *moviePlayerView;

// Drawing
@property(nonatomic, strong) ACEDrawingView *drawView;
@property(weak, nonatomic) IBOutlet UIView *drawContainerView;
@property(weak, nonatomic) IBOutlet UIButton *drawUndoButton;
@property(nonatomic, strong) IBOutlet WKColorPickerView *colorPickerView;
@property(nonatomic, strong) NSArray *colorPickerColors;
@property(nonatomic, strong) NSArray *colorPickerGrayscaleColors;

// Text
@property(nonatomic, strong) SSOEditMediaMovableTextView *textView;
@property(nonatomic) BOOL movingTextView;

// Brightness & Contrast
@property(strong, nonatomic) CIContext *filterContext;
@property(weak, nonatomic) IBOutlet UIView *brightnessContainerView;
@property(weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property(weak, nonatomic) IBOutlet UILabel *contrastLabel;
@property(weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property(weak, nonatomic) IBOutlet UISlider *contrastSlider;

// Crop
@property(weak, nonatomic) IBOutlet UIView *cropContainerView;
@property(weak, nonatomic) IBOutlet UIButton *confirmCropButton;
@property(weak, nonatomic) IBOutlet UIButton *cancelCropButton;
@property(strong, nonatomic) UIView *imageCropperContainerView;
//@property(strong, nonatomic) YKImageCropperView *imageCropperView;
@property(strong, nonatomic) PECropView *imageCropperView;
@property(weak, nonatomic) IBOutlet UIView *cropViewFrameView;

// Helper
@property(strong, nonatomic) SSOBrightnessContrastHelper *brightnessContrastHelper;

@end

@implementation WKEditMediaViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

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

        //        self.modifiedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        //        self.modifiedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //        self.modifiedImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        self.modifiedImageView.clipsToBounds = YES;
        //        self.modifiedImageView.image = self.image;
        //        [self.view insertSubview:self.modifiedImageView atIndex:1];
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

    // Setup the brightness and contrast view
    self.filterContext = [CIContext contextWithOptions:nil];
  
    self.brightnessContrastHelper = [[SSOBrightnessContrastHelper alloc] init];
    self.brightnessContrastHelper.imageViewToEdit = self.imageView;
    self.brightnessContrastHelper.imageToEdit = self.image;

    self.brightnessContainerView.backgroundColor = [UIColor clearColor];
    BrightnessContrastSlidersView *containerView = [NSBundle loadBrightnessContrastSliderView];
    // Set the view for the helper
    [self.brightnessContrastHelper setView:containerView];

    [self.brightnessContainerView addSubview:containerView];
    // Set the container inside the view to have constraints on the edges
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.brightnessContainerView);
    }];

    // Setup the image cropper view
    self.imageCropperContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.imageCropperContainerView.backgroundColor = [UIColor blackColor];
    self.imageCropperContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.imageCropperContainerView aboveSubview:self.overlayView];

    //  self.imageCropperView = [[YKImageCropperView alloc] initWithFrame:CGRectMake(0.0f, self.isPhone ? 60.0f : 100.0f, self.view.frame.size.width,
    //  self.view.frame.size.height - (self.isPhone ? 180.0f : 260.0f))];
    self.imageCropperView = [[PECropView alloc] initWithFrame:self.cropViewFrameView.frame];
    // self.imageCropperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.cropViewFrameView addSubview:self.imageCropperView];

    self.cropContainerView.backgroundColor = [UIColor clearColor];
    [self.confirmCropButton setTitle:NSLocalizedString(@"Crop", @"") forState:UIControlStateNormal];
    self.confirmCropButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.confirmCropButton.layer.shadowOpacity = 0.75f;
    self.confirmCropButton.layer.shadowRadius = 1.0f;
    self.confirmCropButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    [self.cancelCropButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    self.cancelCropButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cancelCropButton.layer.shadowOpacity = 0.75f;
    self.cancelCropButton.layer.shadowRadius = 1.0f;
    self.cancelCropButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    // Update the UI
    [self updateUI];
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

#pragma mark - Set Edit Type

- (void)setEditType:(WKEditMediaViewControllerEditType)editType {
    _editType = editType;

    [self updateUI];
}

#pragma mark - Keyboard Methods

- (void)keyboardWillHide {
    self.editType = WKEditMediaViewControllerEditTypeNone;
}

#pragma mark - Update UI

- (void)updateUI {
    switch (self.editType) {
    case WKEditMediaViewControllerEditTypeNone:
        self.drawView.userInteractionEnabled = NO;
        self.drawContainerView.hidden = YES;
        self.drawButton.tintColor = [UIColor whiteColor];
        self.drawButton.alpha = 1.0f;

        self.textView.editable = NO;
        self.textView.userInteractionEnabled = NO;
        [self.textView resignFirstResponder];
        self.textButton.alpha = 1.0f;

        self.brightnessContainerView.hidden = YES;
        self.brightnessButton.alpha = 1.0f;

        self.cropContainerView.hidden = YES;
        self.imageCropperContainerView.hidden = YES;
        self.cropButton.alpha = 1.0f;
        break;

    case WKEditMediaViewControllerEditTypeDrawColor:
        self.drawContainerView.hidden = NO;
        self.colorPickerView.colors = self.colorPickerColors;
        self.drawView.userInteractionEnabled = YES;
        self.drawUndoButton.enabled = ([self.drawView canUndo]);
        self.drawView.lineColor = self.colorPickerView.color;
        self.drawButton.tintColor = self.colorPickerView.color;
        self.drawButton.alpha = 1.0f;

        self.textView.editable = NO;
        self.textView.userInteractionEnabled = NO;
        [self.textView resignFirstResponder];
        self.textButton.alpha = 0.5f;

        self.brightnessContainerView.hidden = YES;
        self.brightnessButton.alpha = 0.5f;

        self.cropContainerView.hidden = YES;
        self.imageCropperContainerView.hidden = YES;
        self.cropButton.alpha = 0.5f;
        break;

    case WKEditMediaViewControllerEditTypeDrawGrayscale:
        self.drawContainerView.hidden = NO;
        self.colorPickerView.colors = self.colorPickerGrayscaleColors;
        self.drawView.userInteractionEnabled = YES;
        self.drawUndoButton.enabled = ([self.drawView canUndo]);
        self.drawView.lineColor = self.colorPickerView.color;
        self.drawButton.tintColor = self.colorPickerView.color;
        self.drawButton.alpha = 1.0f;

        self.textView.editable = NO;
        self.textView.userInteractionEnabled = NO;
        [self.textView resignFirstResponder];
        self.textButton.alpha = 0.5f;

        self.brightnessContainerView.hidden = YES;
        self.brightnessButton.alpha = 0.5f;

        self.cropContainerView.hidden = YES;
        self.imageCropperContainerView.hidden = YES;
        self.cropButton.alpha = 0.5f;
        break;

    case WKEditMediaViewControllerEditTypeText:
        self.drawView.userInteractionEnabled = NO;
        self.drawContainerView.hidden = YES;
        self.drawButton.tintColor = [UIColor whiteColor];
        self.drawButton.alpha = 0.5f;

        self.textView.editable = YES;
        self.textView.userInteractionEnabled = YES;
        [self.textView becomeFirstResponder];
        self.textButton.alpha = 1.0f;

        self.brightnessContainerView.hidden = YES;
        self.brightnessButton.alpha = 0.5f;

        self.cropContainerView.hidden = YES;
        self.imageCropperContainerView.hidden = YES;
        self.cropButton.alpha = 0.5f;
        break;

    case WKEditMediaViewControllerEditTypeBrightness:
        self.drawView.userInteractionEnabled = NO;
        self.drawContainerView.hidden = YES;
        self.drawButton.tintColor = [UIColor whiteColor];
        self.drawButton.alpha = 0.5f;

        self.textView.editable = NO;
        self.textView.userInteractionEnabled = NO;
        [self.textView resignFirstResponder];
        self.textButton.alpha = 0.5f;

        self.brightnessContainerView.hidden = NO;
        self.brightnessButton.alpha = 1.0f;

        self.cropContainerView.hidden = YES;
        self.imageCropperContainerView.hidden = YES;
        self.cropButton.alpha = 0.5f;
        break;

    case WKEditMediaViewControllerEditTypeCrop:
        self.drawView.userInteractionEnabled = NO;
        self.drawContainerView.hidden = YES;
        self.drawButton.tintColor = [UIColor whiteColor];
        self.drawButton.alpha = 0.5f;

        self.textView.editable = NO;
        self.textView.userInteractionEnabled = NO;
        [self.textView resignFirstResponder];
        self.textButton.alpha = 0.5f;

        self.brightnessContainerView.hidden = YES;
        self.brightnessButton.alpha = 0.5f;

        self.cropContainerView.hidden = NO;
        self.imageCropperView.image = (self.modifiedImageView.image) ? self.modifiedImageView.image : self.imageView.image;
        self.imageCropperContainerView.hidden = NO;
        self.cropButton.alpha = 1.0f;
        break;

    default:
        break;
    }
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
    [self updateUI];
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

#pragma mark - Filters Adjustments

- (void)adjustFilters {
    CGFloat brightnessValue = self.brightnessSlider.value / self.brightnessSlider.maximumValue;
    CGFloat contrastValue = self.contrastSlider.value / 40.0f;

    CIImage *filteredImage = [[CIImage alloc] initWithCGImage:self.image.CGImage options:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:filteredImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:brightnessValue] forKey:kCIInputBrightnessKey];
    [filter setValue:[NSNumber numberWithFloat:contrastValue] forKey:kCIInputContrastKey];
    CIImage *outputImage = filter.outputImage;
    CGImageRef imageRef = [self.filterContext createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:self.image.scale orientation:self.image.imageOrientation];
    self.modifiedImageView.image = newImage;
    CGImageRelease(imageRef);
}

#pragma mark - Crop Image

- (void)cropImage {
    // self.modifiedImageView.image = [self.imageCropperView editedImage];
    self.modifiedImageView.image = self.imageCropperView.croppedImage;
}

#pragma mark - Button Actions

- (IBAction)selectedColorChanged:(id)sender {
    [self updateUI];
}

- (IBAction)undoButtonTouched:(id)sender {
    [self.drawView undoLatestStep];

    [self updateUI];
}

- (IBAction)brightnessValueChanged:(id)sender {
    [self adjustFilters];
}

- (IBAction)contrastValueChanged:(id)sender {
    [self adjustFilters];
}

- (IBAction)confirmCropButtonTouched:(id)sender {
    [self cropImage];
    self.editType = WKEditMediaViewControllerEditTypeNone;
}

- (IBAction)cancelCropButtonTouched:(id)sender {
    self.editType = WKEditMediaViewControllerEditTypeNone;
}

- (IBAction)drawButtonTouched:(id)sender {
    WKEditMediaViewControllerEditType type = WKEditMediaViewControllerEditTypeDrawColor;
    self.colorPickerView.color = [self.colorPickerColors objectAtIndex:0];
    if (self.editType == WKEditMediaViewControllerEditTypeDrawColor) {
        type = WKEditMediaViewControllerEditTypeDrawGrayscale;
        self.colorPickerView.color = [self.colorPickerGrayscaleColors objectAtIndex:0];
    } else if (self.editType == WKEditMediaViewControllerEditTypeDrawGrayscale) {
        type = WKEditMediaViewControllerEditTypeNone;
    }
    self.editType = type;
}

- (IBAction)textButtonTouched:(id)sender {
    WKEditMediaViewControllerEditType type = WKEditMediaViewControllerEditTypeText;
    if (self.editType == WKEditMediaViewControllerEditTypeText) {
        type = WKEditMediaViewControllerEditTypeNone;
    }
    self.editType = type;
}

- (IBAction)brightnessButtonTouched:(id)sender {
    WKEditMediaViewControllerEditType type = WKEditMediaViewControllerEditTypeBrightness;
    if (self.editType == WKEditMediaViewControllerEditTypeBrightness) {
        type = WKEditMediaViewControllerEditTypeNone;
    }
    self.editType = type;
}

- (IBAction)cropButtonTouched:(id)sender {
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
