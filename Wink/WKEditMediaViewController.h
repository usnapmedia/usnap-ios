//
//  WKEditImageViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"
#import "ACEDrawingView.h"
#import "WKMoviePlayerView.h"
#import "WKShareViewController.h"
#import "WKColorPickerView.h"
#import "YKImageCropperView.h"
#import <PECropViewController.h>
#import <Masonry.h>
#import "SSOEditMediaMovableTextView.h"

#import <RSKImageCropViewController.h>

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

@interface WKEditMediaViewController : WKViewController {
}

// Media
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSURL *mediaURL;

// UI
@property(weak, nonatomic) IBOutlet UIView *overlayView;
@property(weak, nonatomic) IBOutlet UIImageView *watermarkImageView;
@property(weak, nonatomic) IBOutlet UIButton *postButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UIImageView *drawIconBorderImageView;
@property(weak, nonatomic) IBOutlet UIButton *drawButton;
@property(weak, nonatomic) IBOutlet UIButton *textButton;
@property(weak, nonatomic) IBOutlet UIButton *brightnessButton;
@property(weak, nonatomic) IBOutlet UIButton *cropButton;

// State outlets, to clean

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
@property(weak, nonatomic) IBOutlet UIView *editAccessoriesContainerView;
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
@property(strong, nonatomic) RSKImageCropViewController *imageCropperView;
@property(weak, nonatomic) IBOutlet UIView *cropViewFrameView;

// Containers

@property(strong, nonatomic) BrightnessContrastSlidersView *containerView;

// Helper
@property(strong, nonatomic) SSOBrightnessContrastHelper *brightnessContrastHelper;

// Button Actions
- (IBAction)drawButtonTouched:(id)sender;
- (IBAction)textButtonTouched:(id)sender;
- (IBAction)brightnessButtonTouched:(id)sender;
- (IBAction)cropButtonTouched:(id)sender;
- (IBAction)postButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end
