//
//  SSOMediaEditStateCrop.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateCrop.h"

@implementation SSOMediaEditStateCrop

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumCrop];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)cropButtonTouched {

    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;
    self.editMediaVC.textButton.tintColor = [UIColor whiteColor];

    self.editMediaVC.brightnessButton.alpha = 0.5f;
    self.editMediaVC.textButton.tintColor = [UIColor whiteColor];

    self.editMediaVC.cropButton.alpha = 1.0f;

    self.editMediaVC.editAccessoriesContainerView.hidden = YES;

    RSKImageCropViewController *cropperVC = [[RSKImageCropViewController alloc] initWithImage:self.editMediaVC.imageView.image];
    cropperVC.delegate = self;
    //@FIXME: should be based on the format of the image
    cropperVC.cropMode = RSKImageCropModeSquare;
    [self.editMediaVC presentViewController:cropperVC animated:YES completion:nil];
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
                                     self.editMediaVC.imageView.image = croppedImage;
                                   }];
}

@end
