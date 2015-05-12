//
//  SSOUSnapLightButton.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOUSnapLightButton.h"
#import "SSOThemeHelper.h"

#define kUSnapLightButtonFontSize 14.0f

@implementation SSOUSnapLightButton

- (void)awakeFromNib {
    [self initialize];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.titleLabel.font = [SSOThemeHelper helveticaNeueLightFontWithSize:kUSnapLightButtonFontSize];
    [self setTitleColor:[SSOThemeHelper firstColor] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
}

@end
