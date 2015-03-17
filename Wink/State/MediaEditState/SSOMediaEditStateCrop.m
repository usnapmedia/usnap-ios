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
    self.editMediaVC.drawContainerView.hidden = YES;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;

    self.editMediaVC.textView.editable = NO;
    self.editMediaVC.textView.userInteractionEnabled = NO;
    [self.editMediaVC.textView resignFirstResponder];
    self.editMediaVC.textButton.alpha = 0.5f;

    self.editMediaVC.editAccessoriesContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;

    self.editMediaVC.cropContainerView.hidden = NO;
    self.editMediaVC.imageCropperContainerView.hidden = NO;
    self.editMediaVC.cropButton.alpha = 1.0f;

    self.editMediaVC.imageCropperView = [[RSKImageCropViewController alloc] initWithImage:self.editMediaVC.imageView.image];
    self.editMediaVC.imageCropperView.delegate = self;
    self.editMediaVC.imageCropperView.cropMode = RSKImageCropModeSquare;

    [self.editMediaVC.navigationController pushViewController:self.editMediaVC.imageCropperView animated:YES];

    // L4Z3r : I'll leave the navigationController commented for now as I don't know what should we do for iPad

    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.editMediaVC.imageCropperView];
    //
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //    }
    //     [self.editMediaVC presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - RSKImageCropViewControllerDelegate

/**
 *  RSKImageCropViewControllerDelegate action when pressing back button
 *
 *  @param controller the RSKImageCropViewController
 */
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

/**
 *  RSKImageCropViewControllerDelegate action when pressing confirm button to crop the image
 *
 *  @param controller the RSKImageCropViewController
 *  @param croppedImage the returned cropped image
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    self.editMediaVC.imageView.image = croppedImage;
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
