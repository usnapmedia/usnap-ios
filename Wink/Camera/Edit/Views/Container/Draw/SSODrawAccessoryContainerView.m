//
//  SSODrawAccessoryContainerView.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSODrawAccessoryContainerView.h"
#import "SSOColorPickerContainerView.h"

#define kFirstPointSize 5.0f
#define kSecondPointSize 10.0f
#define kThirdPointSize 15.0f

@interface SSODrawAccessoryContainerView ()

@property(weak, nonatomic) IBOutlet UIView *viewTenPoints;
@property(weak, nonatomic) IBOutlet UIView *viewFifteenPoints;

@end

@implementation SSODrawAccessoryContainerView

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];

    self.viewTenPoints.layer.cornerRadius = self.viewTenPoints.frame.size.width/2;
    self.viewFivePoints.layer.cornerRadius = self.viewFivePoints.frame.size.width/2;
    self.viewFifteenPoints.layer.cornerRadius = self.viewFifteenPoints.frame.size.width/2;
}

/**
 *  Reset the colors of all views
 *
 */

- (void)resetColors
{
    self.viewFivePoints.backgroundColor = [UIColor blackColor];
    self.viewTenPoints.backgroundColor = [UIColor blackColor];
    self.viewFifteenPoints.backgroundColor = [UIColor blackColor];
}

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
    [self resetColors];
    [self.delegate drawContainer:self didChangePointSize:kFirstPointSize withButtonView:self.viewFivePoints];
}

/**
 *  When the second point size button is pressed
 *
 *  @param sender the button
 */
- (IBAction)secondPointSizeButtonPressed:(id)sender {
    [self resetColors];
    [self.delegate drawContainer:self didChangePointSize:kSecondPointSize withButtonView:self.viewTenPoints];
}

/**
 *  When the third point size button is pressed
 *
 *  @param sender the button
 */
- (IBAction)thridPointSizeButtonPressed:(id)sender {
    [self resetColors];
    [self.delegate drawContainer:self didChangePointSize:kThirdPointSize withButtonView:self.viewFifteenPoints];
}

@end
