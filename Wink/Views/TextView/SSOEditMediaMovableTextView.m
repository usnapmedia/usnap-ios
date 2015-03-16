//
//  SSOEditMediaMovableTextView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditMediaMovableTextView.h"

@implementation SSOEditMediaMovableTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];

    self.center = CGPointMake(roundf([UIScreen mainScreen].bounds.size.width / 2.0f), roundf([UIScreen mainScreen].bounds.size.height / 2.0f));
    self.selectable = NO;
    self.scrollEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont winkFontAvenirWithSize:60.0f];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.75f;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.returnKeyType = UIReturnKeyDone;

    return self;
}

@end
