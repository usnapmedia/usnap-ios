//
//  WKVideoEditor.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-10-01.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKVideoEditor.h"

@interface WKVideoEditor ()
@property (nonatomic, strong) AVAsset *videoAsset;
@property (nonatomic, strong) UIImage *overlayImage;
@property (nonatomic, copy) void (^videoEditingCompletionBlock)(BOOL success);
@end

@implementation WKVideoEditor

#pragma mark - Export video with overlay

- (void)exportVideo:(AVAsset *)videoAsset overlay:(UIImage *)overlayImage completed:(void (^)(BOOL success))completionBlock {
    self.videoAsset = videoAsset;
    self.overlayImage = overlayImage;
    self.videoEditingCompletionBlock = completionBlock;
    [self videoOutput];
}

- (void)videoOutput {
    
    // 1 - Early exit if there's no video file selected
    if (!self.videoAsset) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Load a Video Asset First"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 2.1 - Audio Track
    AVAssetTrack *assetAudioTrack = (AVAssetTrack *)[self.videoAsset.tracks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType == %@", AVMediaTypeAudio]].lastObject;
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:assetAudioTrack
                         atTime:kCMTimeZero
                          error:nil];
    
    // 3 - Video track
    AVAssetTrack *assetVideoTrack = (AVAssetTrack *)[self.videoAsset.tracks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType == %@", AVMediaTypeVideo]].lastObject;
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:assetVideoTrack
                         atTime:kCMTimeZero
                          error:nil];
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize overlaySize = self.overlayImage.size;
    CGSize videoSize = [videoAssetTrack realSize];
    CGFloat xOffset = (videoSize.width/2.0f - overlaySize.width/2.0f);
    CGFloat yOffset = (videoSize.height/2.0f - overlaySize.height/2.0f);
    UIImageOrientation videoOrientation = [videoAssetTrack videoOrientation];
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (videoOrientation == UIImageOrientationRight) {
        transform = CGAffineTransformMakeTranslation(-yOffset, xOffset);
    }
    else if (videoOrientation == UIImageOrientationLeft) {
        transform = CGAffineTransformMakeTranslation(yOffset, -xOffset);
    }
    else if (videoOrientation == UIImageOrientationUp) {
        transform = CGAffineTransformMakeTranslation(-xOffset, -yOffset);
    }
    else if (videoOrientation == UIImageOrientationDown) {
        transform = CGAffineTransformMakeTranslation(xOffset, yOffset);
    }
    transform = CGAffineTransformConcat(transform, videoAssetTrack.preferredTransform);
    [videolayerInstruction setTransform:transform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    float renderWidth, renderHeight;
    renderWidth = overlaySize.width;
    renderHeight = overlaySize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    // Add the overlay
    [self applyVideoEffectOverlayToComposition:mainCompositionInst size:overlaySize];
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov", arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

#pragma mark - Video Effects

- (void)applyVideoEffectOverlayToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size {

    // 1 - set up the overlay
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.contentsGravity = @"resizeAspect";
    UIImage *overlayImage = self.overlayImage;
    
    [overlayLayer setContents:(id)[overlayImage CGImage]];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    overlayLayer.masksToBounds = YES;
    
    // 2 - set up the parent layer
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    // 3 - apply magic
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}

#pragma mark - Export Video

- (void)exportDidFinish:(AVAssetExportSession *)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.videoEditingCompletionBlock) {
                        self.videoEditingCompletionBlock((error == nil));
                    }
                });
            }];
        }
    }
}

@end
