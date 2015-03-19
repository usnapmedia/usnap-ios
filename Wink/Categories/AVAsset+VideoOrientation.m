//
//  AVAsset+VideoOrientation.m
//  Wink
//
//  Created by Justin Khan on 2015-03-19.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "AVAsset+VideoOrientation.h"

static inline CGFloat RadiansToDegrees(CGFloat radians) { return radians * 180 / M_PI; };

@implementation AVAsset (VideoOrientation)
@dynamic videoOrientation;

- (LBVideoOrientation)videoOrientation {
    NSArray *videoTracks = [self tracksWithMediaType:AVMediaTypeVideo];
    if ([videoTracks count] == 0) {
        return LBVideoOrientationNotFound;
    }

    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    CGAffineTransform txf = [videoTrack preferredTransform];
    CGFloat videoAngleInDegree = RadiansToDegrees(atan2(txf.b, txf.a));

    LBVideoOrientation orientation = 0;
    switch ((int)videoAngleInDegree) {
    case 0:
        orientation = LBVideoOrientationRight;
        break;
    case 90:
        orientation = LBVideoOrientationUp;
        break;
    case 180:
        orientation = LBVideoOrientationLeft;
        break;
    case -90:
        orientation = LBVideoOrientationDown;
        break;
    default:
        orientation = LBVideoOrientationNotFound;
        break;
    }

    return orientation;
}

- (CGAffineTransform)fixOrientation {

    UIImageOrientation orientation = [self getVideoOrientation];
    CGAffineTransform transform = CGAffineTransformIdentity;

    AVAssetTrack *clipVideoTrack = [[self tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize naturalSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);

    CGSize adjustedSize = CGSizeApplyAffineTransform(naturalSize, clipVideoTrack.preferredTransform);
    adjustedSize.width = ABS(adjustedSize.width);
    adjustedSize.height = ABS(adjustedSize.height);

    if (orientation == UIImageOrientationUp)
        return transform;

    //    switch (orientation) {
    //    case UIImageOrientationDown:
    //    case UIImageOrientationDownMirrored:
    //        transform = CGAffineTransformTranslate(transform, adjustedSize.width, adjustedSize.height);
    //        transform = CGAffineTransformRotate(transform, M_PI);
    //        break;
    //
    //    case UIImageOrientationLeft:
    //    case UIImageOrientationLeftMirrored:
    //        transform = CGAffineTransformTranslate(transform, adjustedSize.width, 0);
    //        transform = CGAffineTransformRotate(transform, M_PI_2);
    //        break;
    //
    //    case UIImageOrientationRight:
    //    case UIImageOrientationRightMirrored:
    //        transform = CGAffineTransformTranslate(transform, 0, adjustedSize.height);
    //        transform = CGAffineTransformRotate(transform, -M_PI_2);
    //        break;
    //    case UIImageOrientationUp:
    //    case UIImageOrientationUpMirrored:
    //        break;
    //    }
    //
    //    switch (orientation) {
    //    case UIImageOrientationUpMirrored:
    //    case UIImageOrientationDownMirrored:
    //        transform = CGAffineTransformTranslate(transform, adjustedSize.width, 0);
    //        transform = CGAffineTransformScale(transform, -1, 1);
    //        break;
    //
    //    case UIImageOrientationLeftMirrored:
    //    case UIImageOrientationRightMirrored:
    //        transform = CGAffineTransformTranslate(transform, adjustedSize.height, 0);
    //        transform = CGAffineTransformScale(transform, -1, 1);
    //        break;
    //    case UIImageOrientationUp:
    //    case UIImageOrientationDown:
    //    case UIImageOrientationLeft:
    //    case UIImageOrientationRight:
    //        break;
    //    }

    CGAffineTransform t1 =
        CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height * 1.2) / 2);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);

    return t2;
}

- (UIImageOrientation)getVideoOrientation {
    AVAssetTrack *videoTrack = [[self tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];

    if (size.width == txf.tx && size.height == txf.ty)
        return UIImageOrientationLeft; // return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIImageOrientationRight; // return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIImageOrientationDown; // return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIImageOrientationUp; // return UIInterfaceOrientationPortrait;
}

@end