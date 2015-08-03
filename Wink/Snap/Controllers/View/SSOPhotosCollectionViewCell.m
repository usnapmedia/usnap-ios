//
//  SSOPhotosCollectionViewCell.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOPhotosCollectionViewCell.h"
#import "SSOSnap.h"
#import "SSBaseViewCellProtocol.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SSOPhotosCollectionViewCell () <SSBaseViewCellProtocol>

@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SSOPhotosCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  Fill the cell with all the information needed
 *
 *  @param cellData cellData
 */

- (void)configureCell:(id)cellData {
    NSAssert([cellData isKindOfClass:[SSOSnap class]], @"Cell data has to be a SSOSnap class");
    if ([cellData isKindOfClass:[SSOSnap class]]) {
        SSOSnap *snap = cellData;
        [self.activityIndicator startAnimating];
        NSLog(@"snap.thumbUrl : %@", snap.thumbUrl);
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:snap.thumbUrl]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        [self.activityIndicator stopAnimating];
                                      }];
    }
}

- (void)deviceChangedOrientation:(NSNotification *)notification {
    return;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
    case UIDeviceOrientationPortrait: {
        [self rotateButtons:0];
        break;
    }

    case UIDeviceOrientationLandscapeLeft: {
        [self rotateButtons:M_PI_2];
        break;
    }
    case UIDeviceOrientationLandscapeRight: {
        [self rotateButtons:-M_PI_2];
        break;
    }
    default: { break; }
    }
}

- (void)rotateButtons:(CGFloat)rotation {
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{

                       self.transform = CGAffineTransformMakeRotation(rotation);

                     }
                     completion:nil];
}

@end
