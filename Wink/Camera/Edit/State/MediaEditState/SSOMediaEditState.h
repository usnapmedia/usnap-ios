//
//  SSOMediaEditState.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKEditMediaViewController.h"

typedef enum {
    SSOMediaEditStateEnumNone,
    SSOMediaEditStateEnumDrawColor,
    SSOMediaEditStateEnumDrawGray,
    SSOMediaEditStateEnumText,
    SSOMediaEditStateEnumBrightness,
    SSOMediaEditStateEnumCrop
} SSOMediaEditStateEnum;

@protocol MediaEditStateProtocol <NSObject>

@optional
#pragma mark - Touches

/**
 *  When touch begins
 *
 *  @param touches the touches
 *  @param event   the event
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  When touch moves
 *
 *  @param touches the touches
 *  @param event   the event
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  When touch ends
 *
 *  @param touches the touches
 *  @param event   the event
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  When touch cancels
 *
 *  @param touches the touches
 *  @param event   the event
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

#pragma mark - Actions

/**
 *  Action called when draw button is touched
 */
- (void)drawButtonTouched;

/**
 *  Action called when text button is touched
 */
- (void)textButtonTouched;

/**
 *  Action called when brightness button is touched
 */
- (void)brightnessButtonTouched;

/**
 *  Action called when crop button is touched
 */
- (void)cropButtonTouched;

@end

@interface SSOMediaEditState : NSObject <MediaEditStateProtocol>

@property(weak, nonatomic) WKEditMediaViewController *editMediaVC;
@property BOOL isTextViewMoving;

/**
 *  Get the current state
 *
 *  @return the state
 */
- (SSOMediaEditStateEnum)state;

/**
 *  Set the current state
 *
 *  @param state the state
 */
- (void)setState:(SSOMediaEditStateEnum)state;

@end
