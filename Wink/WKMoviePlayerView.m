//
//  WKMoviePlayerView.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-03.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKMoviePlayerView.h"

@interface WKMoviePlayerView ()
@property (nonatomic, readwrite) CGSize videoSize;
@end

@implementation WKMoviePlayerView

#pragma mark - Initializers

- (id)initWithPath:(NSURL *)path {
    if ((self = [super init])) {
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        // Setup the audio session so the volume respects the silent switch
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        
        // Setup the player
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:path options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.playerLayer];
        
        // Set the video's size
        _videoSize = [((AVAssetTrack *)[asset.tracks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType == %@", AVMediaTypeVideo]].lastObject) realSize];
        
        // Notification for when player finishes playing
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    }
    return self;
}

+ (id)moviePlayerViewWithPath:(NSURL *)path {
    return [[WKMoviePlayerView alloc] initWithPath:path];
}

#pragma mark - View Methods

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - Resetting player to start

- (void)resetPlayer {
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - Notifications

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [self resetPlayer];
    
    if ([self.delegate respondsToSelector:@selector(moviePlayerViewDidFinishPlayingToEndTime:)]) {
        [self.delegate moviePlayerViewDidFinishPlayingToEndTime:self];
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setDelegate:nil];
}

@end
