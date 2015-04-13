//
//  SSORegisterContainerView.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOLoginRegisterDelegate.h"

@interface SSORegisterContainerView : UIView <SSOLoginRegisterDelegate>
@property(weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property(weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property(weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property(weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property(weak, nonatomic) IBOutlet UITextField *textFieldBirthday;
@property(weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property(weak, nonatomic) IBOutlet UIButton *buttonSignUp;
@property(weak, nonatomic) id<SSOLoginRegisterDelegate> delegate;

@end
