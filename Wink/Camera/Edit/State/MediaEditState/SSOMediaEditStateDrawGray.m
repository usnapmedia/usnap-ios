//
//  SSOMediaEditStateDrawGrey.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateDrawGray.h"

@implementation SSOMediaEditStateDrawGray

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumDrawGray];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)drawButtonTouched {
    [super drawButtonTouched];
}


@end
