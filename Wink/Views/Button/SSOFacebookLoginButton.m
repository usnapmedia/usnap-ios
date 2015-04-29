//
//  SSOFacebookLoginButton.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-02-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFacebookLoginButton.h"
#import "UIImage+Resizing.h"

#define kImagePadding 20.0f
#define kImageInsetPadding 20.0f
#define kLoginButtonCornerRadius 5.0f

@implementation SSOFacebookLoginButton

- (void)awakeFromNib {
    // Set facebook button color
    [self setBackgroundColor:[UIColor colorWithRed:59 / 255 green:89 / 255 blue:152 / 255 alpha:1.0]];

    UIImage *buttonImage = [UIImage imageNamed:@"fb_login_button"];
    CGFloat imageSizeRatio = buttonImage.size.width / buttonImage.size.height;
    // New height is the size of the button minus 20 for padding
    CGFloat imageNewHeight = self.frame.size.height - kImagePadding;

    // Resize the button
    buttonImage = [buttonImage scaleToSize:CGSizeMake(imageNewHeight * imageSizeRatio, imageNewHeight)];
    // create the button and assign the image
    [self setImage:buttonImage forState:UIControlStateNormal];

    // Set padding for the image
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -kImageInsetPadding, 0, 0)];

    // Set the background color
    [self setBackgroundColor:[UIColor colorWithRed:59.0 / 255.0 green:89.0 / 255.0 blue:152.0 / 255.0 alpha:1.0]];
    
    // set corner radius
    [self.layer setCornerRadius:kLoginButtonCornerRadius];
    
    [self setTitle:NSLocalizedString(@"facebook_login_button_title", nil) forState:UIControlStateNormal];
}
@end
