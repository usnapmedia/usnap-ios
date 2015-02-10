//
//  WKSettingsViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@interface WKSettingsViewController : WKViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

// UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

// Button Actions
- (IBAction)contactButtonTouched:(id)sender;
- (IBAction)signOutButtonTouched:(id)sender;

@end
