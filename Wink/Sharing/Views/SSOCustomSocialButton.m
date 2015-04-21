//
//  SSOCustomSociaButton.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-20.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCustomSocialButton.h"

@implementation SSOCustomSocialButton

- (instancetype)initWithSocialNetwork:(SelectedSocialNetwork)socialNetwork state:(BOOL)connected {

    if (self = [super init]) {
        _socialNetwork = socialNetwork;
        self.selected = connected;
        [self imageForSocialNetwork];

    }
    return self;
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

-(void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    [self imageForSocialNetwork];
    
}


@end
