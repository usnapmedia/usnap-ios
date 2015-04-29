//
//  WKEditImageViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKMoviePlayerView.h"
#import "WKShareViewController.h"
#import "SSOEditViewControllerProtocol.h"
#import "SSOViewControllerWithLiveFeed.h"

@interface WKEditMediaViewController : SSOViewControllerWithLiveFeed <SSOEditViewControllerProtocol>

// Media
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSURL *mediaURL;

@end
