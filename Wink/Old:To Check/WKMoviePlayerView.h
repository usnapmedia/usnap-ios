//
//  WKMoviePlayerView.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol WKMoviePlayerDelegate;

@interface WKMoviePlayerView : UIView <UITextFieldDelegate>{
    
}

// Player
@property (retain, nonatomic) AVPlayer *player;
@property (retain, nonatomic) AVPlayerLayer *playerLayer;
@property (nonatomic, readonly) CGSize videoSize;

// Delegate
@property (assign, nonatomic) id <WKMoviePlayerDelegate> delegate;

// Intiializers
- (id)initWithPath:(NSURL *)path;
+ (id)moviePlayerViewWithPath:(NSURL *)path;

// Resetting player to start
- (void)resetPlayer;

@end

@protocol WKMoviePlayerDelegate <NSObject>
@optional
- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer;
@end