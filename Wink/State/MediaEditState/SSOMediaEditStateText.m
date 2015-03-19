//
//  SSOMediaEditStateText.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-03-17.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOMediaEditStateText.h"

@interface SSOMediaEditStateText () <UITextViewDelegate>

@property(nonatomic) float keyBoardHeight;

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

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - MediaEditStateProtocol

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Check the point on the view
    CGPoint point = [touches.anyObject locationInView:self.editMediaVC.view];
    // If there is a touch out of the text view, simply dismiss the view
    if (!CGRectContainsPoint(self.editMediaVC.textView.frame, point)) {
        if ([self.editMediaVC.textView isFirstResponder]) {
            [self.editMediaVC.textView resignFirstResponder];
        }
    }
}

- (void)textButtonTouched {

    self.editMediaVC.drawView.userInteractionEnabled = NO;
    self.editMediaVC.drawButton.tintColor = [UIColor whiteColor];
    self.editMediaVC.drawButton.alpha = 0.5f;

    self.editMediaVC.textView.delegate = self;
    // Add an observer for when the keyboard shows to get it's size
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    self.editMediaVC.textView.returnKeyType = UIReturnKeyDefault;
    self.editMediaVC.textView.editable = YES;
    self.editMediaVC.textView.userInteractionEnabled = YES;
    [self.editMediaVC.textView becomeFirstResponder];
    self.editMediaVC.textButton.alpha = 1.0f;

    self.editMediaVC.editAccessoriesContainerView.hidden = YES;
    self.editMediaVC.brightnessButton.alpha = 0.5f;

    self.editMediaVC.cropButton.alpha = 0.5f;
}

- (void)keyboardWasShown:(NSNotification *)aNotification {

    NSDictionary *info = [aNotification userInfo];
    self.keyBoardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    [self moveTextViewAboveKeyboard];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    CGPoint center = self.editMediaVC.textView.center;
    CGSize size = [self.editMediaVC.textView sizeThatFits:CGSizeMake(self.editMediaVC.textView.superview.bounds.size.width,
                                                                     self.editMediaVC.textView.superview.bounds.size.height -
                                                                         self.keyBoardHeight)];
    self.editMediaVC.textView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    self.editMediaVC.textView.center = center;

    // If the string is empty does not return to next line
    NSRange range = [textView.text rangeOfString:@"\n"];
    if (textView.text.length == 0) {
        if (range.location != NSNotFound) {
            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@""];
        }
    }

    [self moveTextViewAboveKeyboard];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    // Check if the texView is empty. If it is then don't allow the user to make returns
    if (textView.text.length == 0) {
        if ([text isEqualToString:@"\n"]) {
            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

- (void)moveTextViewAboveKeyboard {
    CGRect rectTextView = self.editMediaVC.textView.frame;

    if (CGRectGetMaxY(rectTextView) >= self.keyBoardHeight) {
        [UIView animateWithDuration:0.3
                         animations:^{
                           self.editMediaVC.textView.frame =
                               CGRectMake(rectTextView.origin.x, self.editMediaVC.view.frame.size.height - self.keyBoardHeight - rectTextView.size.height - 20,
                                          rectTextView.size.width, rectTextView.size.height);
                         }];
    }
}

@end
