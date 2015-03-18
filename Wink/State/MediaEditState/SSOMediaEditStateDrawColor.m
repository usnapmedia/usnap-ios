//
//  SSOMediaEditStateDraw.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateDrawColor.h"

@interface SSOMediaEditStateDrawColor ()

@end

@implementation SSOMediaEditStateDrawColor

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumDrawColor];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)drawButtonTouched {
    self.editMediaVC.colorPickerContainerView.colorPickerView.colors = [UIColor colorsArray];
    [super drawButtonTouched];
}
@end
