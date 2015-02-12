//
//  WKVideoEditor.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-10-01.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface WKVideoEditor : NSObject

@property(nonatomic, strong) NSURL *urlOfVideoInCameraRoll;

// Export video with overlay
- (void)exportVideo:(AVAsset *)videoAsset overlay:(UIImage *)overlayImage completed:(void (^)(BOOL success))completionBlock;

@end
