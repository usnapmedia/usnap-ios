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

@property(weak, nonatomic) IBOutlet UIView *viewFivePoints;
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
