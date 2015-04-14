//
//  SSOCustomSignInButton.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCustomSignInButton.h"

@implementation SSOCustomSignInButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self == [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];

    if (selected) {
        self.backgroundColor = [UIColor purpleColorWithAlpha:0.2];

    } else {

        self.backgroundColor = [UIColor greenColorWithAlpha:0.2];
    }
}

@end
