//
//  SSOTextToolController.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-13.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOTextToolController.h"
#import "SSOTextAccessoryContainerView.h"
#import "SSOTextFontCollectionViewProvider.h"
#import "SSOFontCollectionViewCell.h"
#import "UIColor+PickerColors.h"
#import <Masonry.h>

#define kPaddingKeyboardAndTextView 20
#define kTextViewFontSize 40.0f

@interface SSOTextToolController () <SSOColorPickerContainerViewDelegate, SSOProviderDelegate, SSOContainerViewDelegate, UITextViewDelegate>

@property(strong, nonatomic) SSOTextAccessoryContainerView *accessoryContainerView;
@property(strong, nonatomic) SSOColorPickerContainerView *colorPickerContainerView;
@property(strong, nonatomic) SSOTextFontCollectionViewProvider *provider;
@property(weak, nonatomic) UITextView *textView;

@property(strong, nonatomic) UIColor *currentColor;
@property(strong, nonatomic) SSOFontCollectionViewCell *cell;

@property(nonatomic) float keyBoardHeight;

@end

@implementation SSOTextToolController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentColor = [UIColor whiteColor];
    // Initialize the VC to the parent VC
    [self initializeContainerViewToParentVC];
    // Initialize the text view
    [self initializeTextView];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        // Remove the interaction on the text view
        [self.textView setUserInteractionEnabled:NO];
        // Remove oberservers
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
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
    NSAssert([parent respondsToSelector:@selector(textView)], @"Parent view controller should have a text view to write");
    self.textView = parent.textView;

    // Set the provider for the font collection view
    self.provider = [[SSOTextFontCollectionViewProvider alloc] initWithDefaultData];
    // Set the delegate
    self.accessoryContainerView.fontCollectionView.delegate = self.provider;
    self.accessoryContainerView.fontCollectionView.dataSource = self.provider;
    self.provider.delegate = self;
    // Register the XIB
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.accessoryContainerView.fontCollectionView.scrollEnabled = YES;

    self.accessoryContainerView.fontCollectionView.collectionViewLayout = layout;
    [self.accessoryContainerView.fontCollectionView registerNib:[UINib nibWithNibName:@"SSOFontCollectionViewCell" bundle:nil]
                                     forCellWithReuseIdentifier:@"fontCollectionViewCellIdentifier"];

    // Set the background to clear
    [self.accessoryContainerView.fontCollectionView setBackgroundColor:[UIColor clearColor]];
    // Reload the data
    [self.accessoryContainerView.fontCollectionView reloadData];
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
    self.currentColor = color;
    if (!self.cell) {
        self.cell = [[self.accessoryContainerView.fontCollectionView visibleCells] firstObject];
    }
    [self.cell setFontColorWithColor:color];
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

    // If textview is to be under the keyboard, slide it up
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

    if (!self.cell) {
        self.cell = [[self.accessoryContainerView.fontCollectionView visibleCells] firstObject];
    }
    [self.cell setFontColorWithColor:self.currentColor];
    
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

#pragma mark - SSOBaseProviderDelegate

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert([[self.provider.inputData objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]], @"Object data has to be of NSDictionary class");
    NSArray *cells = [self.accessoryContainerView.fontCollectionView visibleCells];
    for (SSOFontCollectionViewCell *cell in cells) {
        [cell setFontColorWithColor:[UIColor whiteColor]];
    }
    self.cell = (SSOFontCollectionViewCell *)[self.accessoryContainerView.fontCollectionView cellForItemAtIndexPath:indexPath];
    [self.cell setFontColorWithColor:self.currentColor];
    NSDictionary *objectData = (NSDictionary *)[self.provider.inputData objectAtIndex:indexPath.row];
    NSAssert([objectData objectForKey:@"font_name"], @"Object data must have the font name at the key font_name");
    [self.textView setFont:[UIFont fontWithName:[objectData objectForKey:@"font_name"] size:kTextViewFontSize]];
}

@end
