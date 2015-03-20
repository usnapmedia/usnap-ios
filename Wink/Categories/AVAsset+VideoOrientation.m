//
//  AVAsset+VideoOrientation.m
//  Wink
//
//  Created by Justin Khan on 2015-03-19.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "AVAsset+VideoOrientation.h"

@implementation AVAsset (VideoOrientation)

+ (CGAffineTransform)fixOrientationWithAsset:(AVAsset *)asset withVideoComposition:(AVMutableVideoComposition *)videoComposition withView:(UIView *)view {

    CGAffineTransform finalTransform;

    UIImageOrientation videoOrientation = [self getVideoOrientationFromAsset:asset];
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    // Set frame of video
    // Set your desired output aspect ratio here. 1.0 for square, 16/9.0 for widescreen, etc.
    CGFloat desiredAspectRatio = view.bounds.size.height / view.bounds.size.width;
    // here we are setting its render size to its height x height (Square)
    CGSize naturalSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
    CGSize adjustedSize = CGSizeApplyAffineTransform(naturalSize, clipVideoTrack.preferredTransform);
    adjustedSize.width = ABS(adjustedSize.width);
    adjustedSize.height = ABS(adjustedSize.height);

    CGFloat newHeight = adjustedSize.height * desiredAspectRatio;
    CGFloat newWidth = adjustedSize.width * desiredAspectRatio;

    CGAffineTransform t1 = CGAffineTransformIdentity;
    CGAffineTransform t2 = CGAffineTransformIdentity;
    CGAffineTransform t3 = CGAffineTransformIdentity;

    videoComposition.renderSize = CGSizeMake(adjustedSize.width, adjustedSize.height);

    switch (videoOrientation) {
    case UIImageOrientationUp:

        newHeight = adjustedSize.width * desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(adjustedSize.width, newHeight);

        t1 = CGAffineTransformRotate(t1, M_PI_2);
        t2 = CGAffineTransformMakeTranslation(adjustedSize.width, -(adjustedSize.height - newHeight) / 2);
        t3 = CGAffineTransformConcat(t1, t2);

        break;
    case UIImageOrientationDown:
        newHeight = adjustedSize.width * desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(adjustedSize.width, newHeight);

        t1 = CGAffineTransformRotate(t1, M_PI + M_PI_2);
        t2 = CGAffineTransformMakeTranslation(0, adjustedSize.height - (adjustedSize.height - newHeight) / 2);
        t3 = CGAffineTransformConcat(t1, t2);
        break;
    case UIImageOrientationRight:
        newWidth = adjustedSize.width / desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(newWidth, adjustedSize.height);

        t1 = CGAffineTransformRotate(t1, 0);
        t2 = CGAffineTransformMakeTranslation((adjustedSize.height - newWidth) / 2, 0);
        t3 = CGAffineTransformConcat(t1, t2);
        break;
    case UIImageOrientationLeft:
        newWidth = adjustedSize.height * desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(newWidth, adjustedSize.width);

        t1 = CGAffineTransformRotate(t1, M_PI);
        t2 = CGAffineTransformMakeTranslation(adjustedSize.width - (adjustedSize.width - newWidth) / 2, newWidth);
        t3 = CGAffineTransformConcat(t1, t2);
        break;
    default:
        NSLog(@"no supported orientation has been found in this video");
        break;
    }

    finalTransform = t3;

    return finalTransform;
}

+ (UIImageOrientation)getVideoOrientationFromAsset:(AVAsset *)asset {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
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