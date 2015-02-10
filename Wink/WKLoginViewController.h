//
//  WKLoginViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@interface WKLoginViewController : WKViewController <UITextFieldDelegate> {
    
}

// UI
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

// Button Actions
- (IBAction)loginButtonTouched:(id)sender;

@end
