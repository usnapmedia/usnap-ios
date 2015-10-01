//
//  SSOPhotoDetailCommentsViewController.h
//  uSnap
//
//  Created by Yanick Lavoie on 2015-09-29.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOSnap.h"

@interface SSOPhotoDetailCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *items;
@property (assign) BOOL loved;
@property (strong, nonatomic) SSOSnap *snap;
@property (weak, nonatomic) IBOutlet UITextField *addCommentTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsTableHeightConstraint;

@end
