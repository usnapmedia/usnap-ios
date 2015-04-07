//
//  SSODrawTool.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSODrawTool.h"

@implementation SSODrawTool

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        [self initializeButtonUI];
    }
    return self;
}

/**
 *  Initialize the button UI
 */
- (void)initializeButtonUI {
    [self.toolButton setTitle:NSLocalizedString(@"edit-media.toolbar.draw-button", @"Draw edit button") forState:UIControlStateNormal];
    [self.toolButton setBackgroundImage:[UIImage imageNamed:@"drawIconBorder"] forState:UIControlStateNormal];
}

#pragma mark - SSOEditToolButtonProtocol

/**
 *  When the tool button is touched
 *
 *  @param button the button
 */
- (void)toolButtonTouched:(UIButton *)button {
}

@end
