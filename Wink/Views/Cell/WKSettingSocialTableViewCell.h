//
//  WKSettingSocialTableViewCell.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-11.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKSettingsSocialCellDelegate;

@interface WKSettingSocialTableViewCell : UITableViewCell

- (void)configureCell:(id)data;

@property(weak, nonatomic) id<WKSettingsSocialCellDelegate> delegate;

@end

@protocol WKSettingsSocialCellDelegate <NSObject>

@required

/**
 *  Send the switchValue to the settingsVC and store it into userDefaults
 *
 *  @param cell        the cell
 *  @param switchValue BOOL
 */
- (void)switchValueHasChanged:(WKSettingSocialTableViewCell *)cell withSwitch:(UISwitch *)theSwitch;

@end
