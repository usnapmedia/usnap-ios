//
//  SSOSettingsViewController.h
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-05.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOUser.h"

@interface SSOSettingsViewController : UIViewController

@property(strong, nonatomic) SSOUser *currentUser;

@end
