//
//  SSORecentPhotosViewController.h
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-27.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSORecentPhotosViewController : UIViewController

#pragma mark - Setters

/**
 *  Set the data for the provider
 *
 *  @param data the data
 */
- (void)setInputData:(NSMutableArray *)data;

#pragma mark - Animations

/**
 *  Display the loading overlay view
 */
- (void)displayLoadingOverlay;

/**
 *  Hide the loading overlay view
 */
- (void)hideLoadingOverlay;

@end
