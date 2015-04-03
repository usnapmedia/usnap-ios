//
//  SSOMediaEditState.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditState.h"

@interface SSOMediaEditState ()

/**
 *  The current state
 */
@property(nonatomic) SSOMediaEditStateEnum state;

@end
@implementation SSOMediaEditState
@synthesize state = _state;

#pragma mark - Getter

- (SSOMediaEditStateEnum)state {
    return _state;
}

#pragma mark - Setter

- (void)setState:(SSOMediaEditStateEnum)state {
    _state = state;
}

@end
