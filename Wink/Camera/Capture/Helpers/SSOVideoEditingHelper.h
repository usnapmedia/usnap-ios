//
//  SSOVideoEditingHelper.h
//  Wink
//
//  Created by Justin Khan on 2015-03-23.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOVideoEditingHelper : NSObject

// @TODO: Add comments
// @TODO: Simplify

/**
 *  Initially video doesn't have the correct orientation. Rotate it and translate it
 *
 *  @param asset
 *  @param videoComposition
 *  @param view             Container view of camera
 *
 *  @return Transform to correct the orientation
 */
+ (CGAffineTransform)fixOrientationWithAsset:(AVAsset *)asset withVideoComposition:(AVMutableVideoComposition *)videoComposition withView:(UIView *)view;

/**
 *  Get the orientation of a video
 *
 *  @param asset
 *
 *  @return UIImageOrientation
 */
+ (UIImageOrientation)getVideoOrientationFromAsset:(AVAsset *)asset;

/**
 *  Crop video
 *
 *  @param mediaURL    URL of video
 *  @param statusBlock Status block to be passed into exporter
 *  @param view        Container view that holds the camera
 */
+ (void)cropVideo:(NSURL *)mediaURL withStatus:(void (^)(AVAssetExportSessionStatus, AVAssetExportSession *))statusBlock inContainerView:(UIView *)view;

@end
