//
//  SSOUSnapButton.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOUSnapButton.h"
#import "SSOThemeHelper.h"

#define kUSnapButtonFontSize 10.0f
#define kUSnapButtonRadius 5.0f

@implementation SSOUSnapButton

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
    self.titleLabel.font = [UIFont systemFontOfSize:kUSnapButtonFontSize];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [SSOThemeHelper firstColor];
    self.layer.cornerRadius = kUSnapButtonRadius;
}


@end
