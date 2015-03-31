//
//  WKShareViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-08.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@class GCPlaceholderTextView;

@interface WKShareViewController : WKViewController <UITextViewDelegate> {
    
}

// Media
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *modifiedImage;
@property (nonatomic, strong) UIImage *overlayImage;

// UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *placeholderTextView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *socialMediaContainerView;
@property (weak, nonatomic) IBOutlet UIButton *socialMediaButton;

// Button Actions
- (IBAction)shareButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;
- (IBAction)socialMediaButtonTouched:(id)sender;

@end