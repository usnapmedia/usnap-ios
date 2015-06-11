//
//  SSOTopPhotosCollectionViewCell.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTopPhotosCollectionViewCell.h"
#import "SSOSnap.h"
#import "SSOThemeHelper.h"
#import <SSBaseViewCellProtocol.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOTopPhotosCollectionViewCell () <SSBaseViewCellProtocol>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end

@implementation SSOTopPhotosCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - SSBaseViewCellProtocol

- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOSnap class]], @"Cell data has to be of SSOSnap class");
    if ([cellData isKindOfClass:[SSOSnap class]]) {
        SSOSnap *snap = (SSOSnap *)cellData;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:snap.thumbUrl]];
        [self.nameLabel setText:snap.username];
        //@FIXME
        // Set the usnap points button
        if ([snap.fbLikes integerValue] > 1) {
            [self.pointsLabel
                setText:[NSString
                            stringWithFormat:NSLocalizedString(@"fan-page.top-photos.points-label-plural", @"Number of points label in plural"), snap.fbLikes]];
        } else {
            // Check if the fblikes is actually set, else, just write 0
            if (!snap.fbLikes) {
                [self.pointsLabel
                    setText:[NSString stringWithFormat:NSLocalizedString(@"fan-page.top-photos.points-label-single", @"Number of points label in plural"), @0]];
            } else {
                [self.pointsLabel
                    setText:[NSString stringWithFormat:NSLocalizedString(@"fan-page.top-photos.points-label-single", @"Number of points label in plural"),
                                                       snap.fbLikes]];
            }
        }

        [self.pointsLabel setTextColor:[SSOThemeHelper firstColor]];
        self.nameLabel.font = [SSOThemeHelper avenirLightFontWithSize:12];
        self.pointsLabel.font = [SSOThemeHelper avenirLightFontWithSize:10];
    }
}

@end
