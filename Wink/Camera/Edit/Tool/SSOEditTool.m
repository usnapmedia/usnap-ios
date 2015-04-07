//
//  SSOEditTool.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditTool.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "UnresolvedMessage"

@implementation SSOEditTool

#pragma clang diagnostic pop


#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        // Instantiate the button and set it's selector to the protocol
        self.toolButton = [SSOToolButton new];
        // Check that the method is implemented
        if ([self respondsToSelector:@selector(toolButtonTouched:)]) {
            [self.toolButton addTarget:self action:@selector(toolButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

@end
