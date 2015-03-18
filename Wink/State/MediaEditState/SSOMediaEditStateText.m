//
//  SSOMediaEditStateText.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateText.h"

@interface SSOMediaEditStateText () <UITextViewDelegate>

@end

@implementation SSOMediaEditStateText

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the current state
        [self setState:SSOMediaEditStateEnumText];
    }
    return self;
}

#pragma mark - MediaEditStateProtocol

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Check the point on the view
    CGPoint point = [touches.anyObject locationInView:self.editMediaVC.view];
    // If there is a touch out of the text view, simply dismiss the view
    if (!CGRectContainsPoint(self.editMediaVC.textView.bounds, point)) {
        if ([self.editMediaVC.textView isFirstResponder]) {
            [self.editMediaVC.textView resignFirstResponder];
        }
    }
}

- (void)textButtonTouched {

    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;

    self.editMediaVC.textView.editable = YES;
    self.editMediaVC.textView.userInteractionEnabled = YES;
    [self.editMediaVC.textView becomeFirstResponder];
    self.editMediaVC.textView.delegate = self;
    self.editMediaVC.textButton.alpha = 1.0f;

    self.editMediaVC.editAccessoriesContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;

    self.editMediaVC.cropButton.alpha = 0.5f;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    CGPoint center = textView.center;
    CGSize size = [textView sizeThatFits:textView.superview.bounds.size];
    textView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    textView.center = center;

    NSRange range = [textView.text rangeOfString:@"\n"];
    if (range.location != NSNotFound) {
        textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@""];
    }
}


@end
