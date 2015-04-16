//
//  SSOAnimatableView.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <pop/POP.h>

@protocol SSOAnimatableView <NSObject>

/**
 *  Display the view
 *
 *  @param animated if animated
 */
- (void)displayView:(BOOL)animated;

/**
 *  Hide the view
 *
 *  @param animated if animated
 */
- (void)hideView:(BOOL)animated;

@end