//
//  WKSettingSocialTableViewCell.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-11.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "WKSettingSocialTableViewCell.h"

@interface WKSettingSocialTableViewCell ()

@property(weak, nonatomic) IBOutlet UILabel *labelNameNetwork;
@property(weak, nonatomic) IBOutlet UISwitch *switchNetwork;

@end

@implementation WKSettingSocialTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(id)data {
    // We pass a dictionnary with the name of the socialNetwork and the value of the switch
    self.labelNameNetwork.text = [data valueForKey:@"name"];
    self.switchNetwork.on = [[data objectForKey:@"switchValue"] boolValue];
}
- (IBAction)switchValueChanged:(UISwitch *)sender {
    [self.delegate switchValueHasChanged:self withSwitchValue:[sender isOn]];
}

@end
