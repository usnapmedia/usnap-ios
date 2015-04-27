//
//  SSOTextFieldWittUnderline.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTextFieldWithUnderline.h"
#import "SSOScreenSizeHelper.h"

@implementation SSOTextFieldWithUnderline

-(void)awakeFromNib {
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {

        
        //[self setAdjustsFontSizeToFitWidth:YES];
    }

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.layer.sublayers.count == 1) {
        
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - [SSOScreenSizeHelper bottomMarginForTextField].floatValue, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:bottomBorder];
    }
    
}

@end
