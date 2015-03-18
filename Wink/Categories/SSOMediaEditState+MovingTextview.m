//
//  SSOMediaEditState+MovingTextview.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditState+MovingTextview.h"

@implementation SSOMediaEditState (MovingTextview)

#pragma mark - MediaEditStateProtocol

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.editMediaVC.view];
    // Check if the touch is in view
    if (CGRectContainsPoint(self.editMediaVC.textView.frame, point)) {
        self.isTextViewMoving = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // If text was previously selected, drag it around
    if (self.isTextViewMoving) {
        CGPoint point = [touches.anyObject locationInView:self.editMediaVC.view];
        self.editMediaVC.textView.center = point;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Cancel the move
    self.isTextViewMoving = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Cancel the move
    self.isTextViewMoving = NO;
}

@end
