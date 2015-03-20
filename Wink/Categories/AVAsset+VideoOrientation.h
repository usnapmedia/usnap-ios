//
//  AVAsset+VideoOrientation.h
//  Wink
//
//  Created by Justin Khan on 2015-03-19.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (VideoOrientation)

+ (CGAffineTransform)fixOrientationWithAsset:(AVAsset *)asset withVideoComposition:(AVMutableVideoComposition *)videoComposition withView:(UIView *)view;

@end
