//
//  SSORectangleSocialButton.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSORectangleSocialButton.h"
#import "SSOThemeHelper.h"

@implementation SSORectangleSocialButton

- (instancetype)initWithSocialNetwork:(SelectedSocialNetwork)socialNetwork state:(BOOL)connected {

    if (self = [super init]) {
        _socialNetwork = socialNetwork;
        self.selected = connected;
        // [self imageForSocialNetwork];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 2.0;
    }
    return self;
}

- (void)setState:(BOOL)connected forSocialNetwork:(SelectedSocialNetwork)socialNetwork {

    _socialNetwork = socialNetwork;
    self.selected = connected;
    // [self imageForSocialNetwork];
}

/**
 *  Set the image corresponding to the socialNetwork and the state of it's connection
 */
- (void)imageForSocialNetwork {

    NSString *imageName;

    switch (self.socialNetwork) {
    case facebookSocialNetwork:
        imageName = @"ic-facebook";
        break;

    case twitterSocialNetwork:
        imageName = @"ic-twitter";
        break;

    case googleSocialNetwork:
        imageName = @"google-plus";
        break;

    default:
        break;
    }

    if (!self.isSelected) {
        imageName = [imageName stringByAppendingString:@"Off"];
    }
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {

    [super setSelected:selected];

    if (selected) {
        self.backgroundColor = [SSOThemeHelper firstColor];
    }

    else {

        self.backgroundColor = [UIColor lightGrayColor];
    }

    // [self imageForSocialNetwork];
}

@end
