//
//  SSOTextToolController.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTextToolController.h"
#import "SSOTextAccessoryContainerView.h"
#import "SSOEditViewControllerProtocol.h"
#import "UIColor+PickerColors.h"
#import <Masonry.h>

#define kPaddingKeyboardAndTextView 20
#define kKeyboardHeight [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height

@interface SSOTextToolController () <SSOColorPickerContainerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SSOContainerViewDelegate,
                                     UITextViewDelegate>
@property(strong, nonatomic) SSOTextAccessoryContainerView *accessoryContainerView;
@property(strong, nonatomic) SSOColorPickerContainerView *colorPickerContainerView;
@property(weak, nonatomic) UITextView *textView;

@property(nonatomic) float keyBoardHeight;

@end

@implementation SSOTextToolController

#pragma mark - View lifecycle

- (void)willMoveToParentViewController:(UIViewController<SSOEditViewControllerProtocol> *)parent {
    [super willMoveToParentViewController:parent];
    if (parent) {
        NSAssert([parent respondsToSelector:@selector(textView)], @"Parent view controller should have a text view to edit");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the VC to the parent VC
    [self initializeContainerViewToParentVC];
    // Initialize the text view
    [self initializeTextView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Remove the observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization

- (void)initializeContainerViewToParentVC {
    NSAssert([self.parentViewController conformsToProtocol:@protocol(SSOEditViewControllerProtocol)],
             @"Parent view controller must conform to protocol SSOEditViewControllerProtocol");
    UIViewController<SSOEditViewControllerProtocol> *parent = (UIViewController<SSOEditViewControllerProtocol> *)self.parentViewController;

    NSAssert([parent respondsToSelector:@selector(accessoryContainerView)], @"Parent view controller must have a accessory container view");
    self.colorPickerContainerView = [NSBundle loadColorPickerContainerView];
    // Insert view to parent
    [[parent accessoryContainerView] addSubview:_colorPickerContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.colorPickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent accessoryContainerView]);
    }];
    // Set the color picker view
    self.colorPickerContainerView.delegate = self;
    self.colorPickerContainerView.colorPickerView.colors = [UIColor colorsArray];

    // Add the accessory view to the parent VC
    NSAssert([parent respondsToSelector:@selector(subtoolContainerView)], @"Parent view controller must have a subtool container view");
    self.accessoryContainerView = [NSBundle loadTextAccessoryContainerView];
    // Insert view to parent
    [[parent subtoolContainerView] addSubview:_accessoryContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.accessoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent subtoolContainerView]);
    }];

    self.accessoryContainerView.delegate = self;

    // Set the text view
    NSAssert([parent respondsToSelector:@selector(textView)], @"Parent view controller should have a draw view to draw on");
    self.textView = parent.textView;
}

/**
 *  Initialize the text view
 */
- (void)initializeTextView {
    // Add an observer for when the keyboard shows to get it's size
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];

    self.textView.delegate = self;

    // Set the textview to the first responder
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.editable = YES;
    self.textView.userInteractionEnabled = YES;
    [self.textView becomeFirstResponder];
}

#pragma mark - SSOEditToolProtocol

- (void)displayContainerViews:(BOOL)animated {
    [self.subtoolView setHidden:NO];
    [self.subtoolView displayView:animated];
    [self.accessoryView setHidden:NO];
    [self.accessoryView displayView:animated];
    [self.bottomView hideView:animated];
}

- (void)hideContainerViews:(BOOL)animated {
    [self.subtoolView hideView:animated];
    [self.accessoryView hideView:animated];
    [self.bottomView displayView:animated];
}

#pragma mark - SSOColorPickerContainerViewDelegate

- (void)colorPickerDidReset:(SSOColorPickerContainerView *)colorPickerContainerView {
    // Reset the text
    [self.textView setText:@""];
}

- (void)colorPickerDidChangeColor:(SSOColorPickerContainerView *)colorPickerContainerView withColor:(UIColor *)color {
    [self.textView setTextColor:color];
}

#pragma mark - SSODrawContainerViewDelegate

- (void)containerViewDoneButtonPressed:(UIView *)view {
    [self.delegate editToolWillEndEditing:self];
}

/**
 *  Receive the UIKeyboardDidShow notification ,set the keyBoardHeight property and call method to move the textView
 *
 *  @param aNotification UIKeyboardDidShowNotification
 */
- (void)keyboardWasShown:(NSNotification *)aNotification {

    NSDictionary *info = [aNotification userInfo];
    self.keyBoardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    [self moveTextViewAboveKeyboard];
}

/**
 *  Move the textView on top of the keyboard when it appears
 */
- (void)moveTextViewAboveKeyboard {
    CGRect rectTextView = self.textView.frame;

    if (CGRectGetMaxY(rectTextView) >= self.keyBoardHeight) {
        [UIView animateWithDuration:0.3
                         animations:^{
                           self.textView.frame =
                               CGRectMake(rectTextView.origin.x,
                                          self.view.frame.size.height - (self.keyBoardHeight + rectTextView.size.height + kPaddingKeyboardAndTextView),
                                          rectTextView.size.width, rectTextView.size.height);
                         }];
    }
}

#pragma mark - UITouchDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Check the point on the view
    CGPoint point = [touches.anyObject locationInView:self.view];
    // If there is a touch out of the text view, simply dismiss the view
    if (!CGRectContainsPoint(self.textView.frame, point)) {
        if ([self.textView isFirstResponder]) {
            [self.textView resignFirstResponder];
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    CGPoint center = self.textView.center;
    CGSize size =
        [self.textView sizeThatFits:CGSizeMake(self.textView.superview.bounds.size.width, self.textView.superview.bounds.size.height - self.keyBoardHeight)];
    self.textView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    self.textView.center = center;

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

@end
