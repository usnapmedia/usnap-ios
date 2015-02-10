//
//  WKViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@interface WKViewController ()
@property (nonatomic, readwrite)  BOOL isPhone;
@end

@implementation WKViewController

#pragma mark - Initializer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    // Load iPad version if on iPad and it exists
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        NSString *nibNameForiPad = [NSString stringWithFormat:@"%@_iPad", nibNameOrNil];
        if ([[NSBundle mainBundle] pathForResource:nibNameForiPad ofType:@"nib"]) {
            nibNameOrNil = nibNameForiPad;
        }
    }
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
    }
    return self;
}

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the screen name for Google Analytics
    self.screenName = NSStringFromClass([self class]);
    
    // Set if phone or tablet
    self.isPhone = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

@end
