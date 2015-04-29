//
//  SSOSettingsSocialFakeTableViewCell.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-02-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSettingsSocialFakeTableViewCell.h"

@interface SSOSettingsSocialFakeTableViewCell ()

@property(weak, nonatomic) IBOutlet UILabel *socialNetworkLabel;

@end

@implementation SSOSettingsSocialFakeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Utilities

- (void)configureCell:(id)data {
    // We pass a dictionnary with the name of the socialNetwork and the value of the switch
    NSAssert([data isKindOfClass:[NSString class]], @"Data must be of type NSString");
    self.socialNetworkLabel.text = data;
}

@end
