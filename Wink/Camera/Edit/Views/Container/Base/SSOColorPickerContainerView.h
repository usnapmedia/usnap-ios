//
//  SSOColorPickerView.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKColorPickerView.h"

@protocol SSOColorPickerContainerViewDelegate;

@interface SSOColorPickerContainerView : UIView

@property(weak, nonatomic) id<SSOColorPickerContainerViewDelegate> delegate;
@property(weak, nonatomic, readonly) IBOutlet WKColorPickerView *colorPickerView;

/**
 *  Set the reset button image
 *
 *  @param image the image
 */
- (void)setResetButtonImage:(UIImage *)image;

@end

/**
 *  Delegate when the view gets changed
 */
@protocol SSOColorPickerContainerViewDelegate <NSObject>

/**
 *  Called when the view has changed the color
 *
 *  @param colorPickerContainerView the color picker container view
 *  @param color                    the color selected
 */
- (void)colorPickerDidChangeColor:(SSOColorPickerContainerView *)colorPickerContainerView withColor:(UIColor *)color;

/**
 *  Called when the reset button is pressed
 *
 *  @param colorPickerContainerView the color picker container view
 */
- (void)colorPickerDidReset:(SSOColorPickerContainerView *)colorPickerContainerView;

@end
