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
