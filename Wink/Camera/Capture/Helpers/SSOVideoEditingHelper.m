//
//  SSOVideoEditingHelper.m
//  Wink
//
//  Created by Justin Khan on 2015-03-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOVideoEditingHelper.h"

@implementation SSOVideoEditingHelper

+ (CGAffineTransform)fixOrientationWithAsset:(AVAsset *)asset withVideoComposition:(AVMutableVideoComposition *)videoComposition withView:(UIView *)view {

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

    CGAffineTransform rotateTransform = CGAffineTransformIdentity;
    CGAffineTransform translateTransform = CGAffineTransformIdentity;
    CGAffineTransform finalTransform = CGAffineTransformIdentity;

    videoComposition.renderSize = CGSizeMake(adjustedSize.width, adjustedSize.height);

    switch (videoOrientation) {
    case UIImageOrientationUp:

        newHeight = adjustedSize.width * desiredAspectRatio;
        // This is the size of the video that you want to crop
        videoComposition.renderSize = CGSizeMake(adjustedSize.width, newHeight);

        // Rotate to fix orientation of video
        rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI_2);

        // After rotating, you'll need to center the video in it's frame and translate so that it's in the middle of the screen
        translateTransform = CGAffineTransformMakeTranslation(adjustedSize.width, -(adjustedSize.height - newHeight) / 2);
        finalTransform = CGAffineTransformConcat(rotateTransform, translateTransform);

        break;
    case UIImageOrientationDown:
        newHeight = adjustedSize.width * desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(adjustedSize.width, newHeight);

        rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI + M_PI_2);
        translateTransform = CGAffineTransformMakeTranslation(0, adjustedSize.height - (adjustedSize.height - newHeight) / 2);
        finalTransform = CGAffineTransformConcat(rotateTransform, translateTransform);
        break;
    case UIImageOrientationRight:
        newWidth = adjustedSize.width / desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(adjustedSize.height, adjustedSize.height);

        rotateTransform = CGAffineTransformRotate(rotateTransform, 0);
        translateTransform = CGAffineTransformMakeTranslation((adjustedSize.height - newWidth) / 2, 0);
        finalTransform = CGAffineTransformConcat(rotateTransform, translateTransform);
        break;
    case UIImageOrientationLeft:
        newWidth = adjustedSize.height * desiredAspectRatio;
        videoComposition.renderSize = CGSizeMake(newWidth, adjustedSize.width);

        rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI);
        translateTransform = CGAffineTransformMakeTranslation(adjustedSize.width - (adjustedSize.width - newWidth) / 2, newWidth);
        finalTransform = CGAffineTransformConcat(rotateTransform, translateTransform);
        break;
    default:
        break;
    }

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

+ (void)cropVideo:(NSURL *)mediaURL withStatus:(void (^)(AVAssetExportSessionStatus, AVAssetExportSession *))statusBlock inContainerView:(UIView *)view {
    __block AVAssetExportSession *exporter;

    // Load our movie Asset
    AVAsset *asset = [AVAsset assetWithURL:mediaURL];
    // Create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];

    // Create a video composition and preset some settings
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);

    // Set your desired output aspect ratio here. 1.0 for square, 16/9.0 for widescreen, etc.
    CGFloat desiredAspectRatio = view.bounds.size.height / view.bounds.size.width;
    // Here we are setting its render size to its height x height (Square)
    CGSize naturalSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
    CGSize adjustedSize = CGSizeApplyAffineTransform(naturalSize, clipVideoTrack.preferredTransform);
    adjustedSize.width = ABS(adjustedSize.width);
    adjustedSize.height = ABS(adjustedSize.height);
    CGFloat newHeight = clipVideoTrack.naturalSize.height * desiredAspectRatio;
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, newHeight);

    // Create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));

    // Create transform
    AVMutableVideoCompositionLayerInstruction *transformer =
        [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    CGAffineTransform finalTransform = [SSOVideoEditingHelper fixOrientationWithAsset:asset withVideoComposition:videoComposition withView:view];
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    // Add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];

    // Create an Export Path to store the cropped video
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *exportPath = [documentsPath stringByAppendingFormat:@"/CroppedVideo.mp4"];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    // Remove any previous videos at that path
    [[NSFileManager defaultManager] removeItemAtURL:exportUrl error:nil];

    // Export video
    exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = exportUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            statusBlock(exporter.status, exporter);

        });
    }];
}

@end
