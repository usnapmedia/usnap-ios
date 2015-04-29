//
//  SSOToolButton.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOToolButton.h"

@implementation SSOToolButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // the space between the image and text
    CGFloat spacing = 20.0;
    
    // lower the text and push it left so it appears centered below the image
    //    (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered above the text
    // Set the image centered too based on iOS 8 modifications
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height), 0.0, 0.0, -titleSize.width);
}

@end
