//
//  VideoRecordingDelegate.h
//  Wink
//
//  Created by Justin Khan on 2015-03-18.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VideoRecordingDelegate

@required

/**
 *  After video is done recording, re-enable user interaction on the homepage for the camera
 */
- (void)enableUserInteraction;

@end
