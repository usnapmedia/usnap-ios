//
//  WKEditImageViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"
#import "WKMoviePlayerView.h"
#import "WKShareViewController.h"
#import "WKColorPickerView.h"

#import <RSKImageCropViewController.h>

#import "SSBaseCollectionView.h"

#import "SSOEditViewControllerProtocol.h"

@interface WKEditMediaViewController : WKViewController <SSOEditViewControllerProtocol>

// Media
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSURL *mediaURL;

// UI
@property(weak, nonatomic) IBOutlet UIView *overlayView;

@property(weak, nonatomic) IBOutlet SSBaseCollectionView *collectionView;

@end
