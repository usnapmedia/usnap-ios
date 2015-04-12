//
//  SSODrawAccessoryContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSODrawAccessoryContainerView.h"

#define kFirstPointSize 10.0f
#define kSecondPointSize 15.0f
#define kThirdPointSize 20.0f

@implementation SSODrawAccessoryContainerView

#pragma mark - IBAction

/**
 *  When the done button is pressed
 *
 *  @param sender the button
 */
- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate containerViewDoneButtonPressed:self];
}
/**
 *  When the first point size button is pressed
 *
 *  @param sender the button
 */
- (IBAction)firstPointSizeButtonPressed:(id)sender {
    [self.delegate drawContainer:self didChangePointSize:kFirstPointSize];
}

/**
 *  When the second point size button is pressed
 *
 *  @param sender the button
 */
- (IBAction)secondPointSizeButtonPressed:(id)sender {
    [self.delegate drawContainer:self didChangePointSize:kSecondPointSize];
}

/**
 *  When the third point size button is pressed
 *
 *  @param sender the button
 */
- (IBAction)thridPointSizeButtonPressed:(id)sender {
    [self.delegate drawContainer:self didChangePointSize:kThirdPointSize];
}

@end
