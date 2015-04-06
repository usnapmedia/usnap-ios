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
#import "SSOEditMediaMovableTextView.h"

#import <RSKImageCropViewController.h>

#import "SSOColorPickerContainerView.h"
#import "BrightnessContrastSlidersContainerView.h"
#import "SSOBrightnessContrastHelper.h"

#import "SSBaseCollectionView.h"

@interface WKEditMediaViewController : WKViewController {
}

// Media
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSURL *mediaURL;

// UI
@property(weak, nonatomic) IBOutlet UIView *overlayView;
@property(weak, nonatomic) IBOutlet UIButton *drawButton;
@property(weak, nonatomic) IBOutlet UIButton *textButton;
@property(weak, nonatomic) IBOutlet UIButton *brightnessButton;
@property(weak, nonatomic) IBOutlet UIButton *cropButton;

// Media
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *modifiedImageView;
@property(nonatomic, strong) WKMoviePlayerView *moviePlayerView;

// Drawing
@property(nonatomic, strong, readonly) ACEDrawingView *drawView;

// Text
@property(nonatomic, strong) SSOEditMediaMovableTextView *textView;

// Brightness & Contrast
@property(weak, nonatomic) IBOutlet UIView *editAccessoriesContainerView;

// Containers
@property(strong, nonatomic, readonly) BrightnessContrastSlidersContainerView *brightnessContrastContainerView;
@property(strong, nonatomic, readonly) SSOColorPickerContainerView *colorPickerContainerView;

@property (weak, nonatomic) IBOutlet SSBaseCollectionView *collectionView;

// Helper
@property(strong, nonatomic, readonly) SSOBrightnessContrastHelper *brightnessContrastHelper;

@end
