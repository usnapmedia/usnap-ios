//
//  SSOLoginViewController.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "WKViewController.h"
#import "SSOLoginRegisterDelegate.h"

//@protocol LoginViewControllerDelegate;

@interface SSOLoginViewController : UIViewController <UITextFieldDelegate, SSOLoginRegisterDelegate>

@property(weak, nonatomic) id<SSOLoginRegisterDelegate> delegate;

@end

