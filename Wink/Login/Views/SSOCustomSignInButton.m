//
//  SSOCustomSignInButton.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCustomSignInButton.h"
#import "SSOThemeHelper.h"

@implementation SSOCustomSignInButton

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self == [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected {

    [super setSelected:selected];
    UIColor *backgroundColor = [SSOThemeHelper firstColor];
    if (selected) {
        self.backgroundColor = [backgroundColor colorWithAlphaComponent:0.2];

    } else {

        self.backgroundColor = [backgroundColor colorWithAlphaComponent:0.2];
    }
}

@end
