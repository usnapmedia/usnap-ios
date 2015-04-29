//
//  AVAssetTrack+WKAdditions.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-10-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAssetTrack (WKAdditions)

- (BOOL)isPortrait;
- (UIImageOrientation)videoOrientation;
- (CGSize)realSize;

@end
