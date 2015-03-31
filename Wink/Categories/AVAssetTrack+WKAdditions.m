//
//  AVAssetTrack+WKAdditions.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-10-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "AVAssetTrack+WKAdditions.h"

@implementation AVAssetTrack (WKAdditions)

- (BOOL)isPortrait {
    BOOL isPortrait = NO;
    CGAffineTransform videoTransform = self.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isPortrait = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        isPortrait = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        isPortrait = NO;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        isPortrait = NO;
    }
    return isPortrait;
}

- (UIImageOrientation)videoOrientation {
    UIImageOrientation videoOrientation = UIImageOrientationRight;
    CGAffineTransform videoTransform = self.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoOrientation = UIImageOrientationRight;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoOrientation =  UIImageOrientationLeft;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoOrientation =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoOrientation = UIImageOrientationDown;
    }
    return videoOrientation;
}

- (CGSize)realSize {
    CGSize videoSize = self.naturalSize;
    if ([self isPortrait]) {
        videoSize = CGSizeMake(self.naturalSize.height, self.naturalSize.width);
    }
    return videoSize;
}

@end
