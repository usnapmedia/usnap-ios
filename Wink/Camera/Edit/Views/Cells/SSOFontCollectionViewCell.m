//
//  SSOFontCollectionViewCell.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOFontCollectionViewCell.h"

#define kFontNameSize 12.0f
#define kFontExampleSize 17.0f

@interface SSOFontCollectionViewCell ()
@property(weak, nonatomic) IBOutlet UILabel *fontExampleLabel;
@property(weak, nonatomic) IBOutlet UILabel *fontNameLabel;

@end

@implementation SSOFontCollectionViewCell


#pragma mark - SSBaseViewCellProtocol

- (void)configureCell:(id)cellData {
    // Set UI
    [self.fontNameLabel setTextColor:[UIColor whiteColor]];
    [self.fontExampleLabel setTextColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    NSAssert([cellData isKindOfClass:[NSDictionary class]], @"Font collection view cell data must be dictionary");
    NSDictionary *cellDataDictionary = (NSDictionary *)cellData;
    NSAssert([cellDataDictionary objectForKey:@"font_name"], @"font_name key must contain the font name");
    // Set the font
    [self.fontExampleLabel setFont:[UIFont fontWithName:[cellDataDictionary objectForKey:@"font_name"] size:kFontExampleSize]];
    [self.fontNameLabel setText:[cellDataDictionary objectForKey:@"font_name"]];
}

@end
