//
//  SSOEditTool.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSOToolButton.h"

@protocol SSOEditToolDelegate;

/**
 *  Used to have the selector methods for the button
 */
@protocol SSOEditToolButtonProtocol <NSObject>

/**
 *  When the tool bar button is pressed
 *
 *  @param button the button
 */
- (void)toolButtonTouched:(UIButton *)button;

@end

/**
 *  Abstract class, should not be instanciated
 */
@interface SSOEditTool : NSObject <SSOEditToolButtonProtocol>

/**
 *  The tool button in the tool bar view
 */
@property(strong, nonatomic) SSOToolButton *toolButton;

@property(weak, nonatomic) id<SSOEditToolDelegate> delegate;

@end

@protocol SSOEditToolDelegate <NSObject>

- (void)editToolWillBeginEditing:(SSOEditTool *)tool;

- (void)editToolWillEndEditing:(SSOEditTool *)tool;

@end
