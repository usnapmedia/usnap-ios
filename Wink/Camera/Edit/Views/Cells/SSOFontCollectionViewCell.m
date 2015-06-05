//
//  SSOFontCollectionViewCell.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFontCollectionViewCell.h"
#import <CBAutoScrollLabel.h>

#define kFontNameSize 12.0f
#define kFontExampleSize 17.0f

@interface SSOFontCollectionViewCell ()
@property(weak, nonatomic) IBOutlet UILabel *fontExampleLabel;
@property(weak, nonatomic) IBOutlet UILabel *fontNameLabel;
@property(weak, nonatomic) IBOutlet CBAutoScrollLabel *scrollLabel;

@end

@implementation SSOFontCollectionViewCell

#pragma mark - SSBaseViewCellProtocol

- (void)configureCell:(id)cellData {
    // Set UI
    [self.fontExampleLabel setTextColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];

    NSAssert([cellData isKindOfClass:[NSDictionary class]], @"Font collection view cell data must be dictionary");
    NSDictionary *cellDataDictionary = (NSDictionary *)cellData;
    NSAssert([cellDataDictionary objectForKey:@"font_name"], @"font_name key must contain the font name");
    // Set the font
    [self.fontExampleLabel setFont:[UIFont fontWithName:[cellDataDictionary objectForKey:@"font_name"] size:kFontExampleSize]];
    [self setScrollLabelUI];
    [self.scrollLabel setText:[cellDataDictionary objectForKey:@"font_name"]];
    [self.scrollLabel setFont:[UIFont fontWithName:[cellDataDictionary objectForKey:@"font_name"] size:kFontNameSize]];
}

/**
 *  Set the scrolling label UI
 */
- (void)setScrollLabelUI {

    self.scrollLabel.textColor = [UIColor whiteColor];
    self.scrollLabel.labelSpacing = 40;
    self.scrollLabel.pauseInterval = 2;
    self.scrollLabel.scrollSpeed = 15;
    self.scrollLabel.textAlignment = NSTextAlignmentCenter;
    self.scrollLabel.fadeLength = .5f;
    self.scrollLabel.scrollDirection = CBAutoScrollDirectionLeft;
}

- (void)setFontColorWithColor:(UIColor *)color {
    self.fontExampleLabel.textColor = color;
    self.fontNameLabel.textColor = color;
    self.scrollLabel.textColor = color;
}

@end
