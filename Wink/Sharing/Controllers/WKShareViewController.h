//
//  WKShareViewController.h
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-08.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKViewController.h"

@class GCPlaceholderTextView;

@interface WKShareViewController : WKViewController <UITextViewDelegate> {
}

// Media
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSURL *mediaURL;
@property(nonatomic, strong) UIImage *modifiedImage;
@property(nonatomic, strong) UIImage *overlayImage;

@end
