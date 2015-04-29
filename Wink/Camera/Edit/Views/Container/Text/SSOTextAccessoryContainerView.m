//
//  SSOTextAccessoryContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTextAccessoryContainerView.h"

@implementation SSOTextAccessoryContainerView

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate containerViewDoneButtonPressed:self];
}

@end
