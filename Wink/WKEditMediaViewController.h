//
//  WKEditImageViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@interface WKEditMediaViewController : WKViewController {
    
}

// Media
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *mediaURL;

// UI
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *watermarkImageView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *drawIconBorderImageView;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *brightnessButton;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;

// Button Actions
- (IBAction)drawButtonTouched:(id)sender;
- (IBAction)textButtonTouched:(id)sender;
- (IBAction)brightnessButtonTouched:(id)sender;
- (IBAction)cropButtonTouched:(id)sender;
- (IBAction)postButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end
