//
//  SSOGrayBackgroundWithBorderView.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-28.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOGrayBackgroundWithBorderView.h"
#import "SSOThemeHelper.h"

@implementation SSOGrayBackgroundWithBorderView

- (instancetype)init {
    if (self = [super init]) {
        [self initializeUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeUI];
}

- (void)initializeUI {
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = [SSOThemeHelper thirdColor];
}

@end
