//
//  SSOSettingsViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-05-05.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOSettingsViewController.h"
#import "SSOThemeHelper.h"
#import "SSORectangleSocialButton.h"
#import "SSOSocialNetworkAPI+USnap.h"
#import "SSOCustomSocialButton.h"
#import "SSSessionManager.h"
#import "SSOUserConnect.h"
#import "SSOCountableItems.h"
#import "SSOUser.h"

@interface SSOSettingsViewController ()

@property(weak, nonatomic) IBOutlet UIView *customNavBar;
@property(weak, nonatomic) IBOutlet UIView *personalTopBarView;
@property(weak, nonatomic) IBOutlet UIView *avatarView;
@property(weak, nonatomic) IBOutlet UILabel *userFirstLetterLabel;
@property(weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property(weak, nonatomic) IBOutlet UIView *socialTopBarView;
@property(weak, nonatomic) IBOutlet SSORectangleSocialButton *twitterButton;
@property(weak, nonatomic) IBOutlet SSORectangleSocialButton *facebookButton;
@property(weak, nonatomic) IBOutlet SSORectangleSocialButton *googleButton;
@property(weak, nonatomic) IBOutlet UIView *supportTopBarView;
@property(weak, nonatomic) IBOutlet UIButton *helpCenterButton;
@property(weak, nonatomic) IBOutlet UIButton *reportProblemButton;
@property(weak, nonatomic) IBOutlet UIButton *logoutButton;
@property(weak, nonatomic) IBOutlet UIButton *saveButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;

@property(strong, nonatomic) NSDate *birthday;

@end

@implementation SSOSettingsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeUI];
    [self setData];
    [self setDatePicker];
    [self setupSocialButtons];
    [self initializeData];
}

#pragma mark - Initialization

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    self.personalTopBarView.backgroundColor = [SSOThemeHelper thirdColor];
    self.avatarView.backgroundColor = [SSOThemeHelper firstColor];
    self.avatarView.layer.cornerRadius = 5;
    self.avatarView.layer.masksToBounds = YES;
    self.socialTopBarView.backgroundColor = [SSOThemeHelper thirdColor];
    self.supportTopBarView.backgroundColor = [SSOThemeHelper thirdColor];
    [self.helpCenterButton setBackgroundColor:[SSOThemeHelper thirdColor]];
    self.helpCenterButton.layer.cornerRadius = 2;
    self.helpCenterButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.helpCenterButton.layer.borderWidth = 1;
    [self.helpCenterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.reportProblemButton setBackgroundColor:[SSOThemeHelper thirdColor]];
    self.reportProblemButton.layer.cornerRadius = 2;
    self.reportProblemButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.reportProblemButton.layer.borderWidth = 1;
    [self.reportProblemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundColor:[SSOThemeHelper firstColor]];
    self.logoutButton.layer.cornerRadius = 2;
    // The Scrollview needs a width. This will set the width to be the same width of the device
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.viewWidthConstraint.constant = screenWidth;
    //@FIXME: The user can't update his information on this version
    self.userNameTextField.enabled = NO;
    self.birthdayTextField.enabled = NO;
    self.saveButton.hidden = YES;
}

#pragma mark - Data

/**
 *  Set the labels and textfields with user information
 */

- (void)setData {
    NSString *name = [[SSSessionManager sharedInstance] username];
    if (name) {
        NSString *firstLetter = [name substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        self.userFirstLetterLabel.text = firstLetter;
        self.userNameTextField.text = name;
    } else {

        self.userFirstLetterLabel.text = @"?";
    }
}

- (void)initializeData {
    [SSOUserConnect getUserInformationWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      SSOCountableItems *items = [[SSOCountableItems alloc] initWithDictionary:responseObject andClass:[SSOUser class]];
      NSAssert([[items.response firstObject] isKindOfClass:[SSOUser class]], @"User data has to be a SSOUser class");
      if ([[items.response firstObject] isKindOfClass:[SSOUser class]]) {
          SSOUser *user = [items.response firstObject];
          [self setUserFirstLetter:user.firstName];
          self.userNameTextField.text = [NSString stringWithFormat:@"%@", user.username];
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"yyyy-MM-dd"];
          self.birthday = [formatter dateFromString:user.dob];
          [self updateBirthday:nil];
      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){

    }];
}

#pragma mark - Social Buttons

/**
 *  Configure the social buttons
 */

- (void)setupSocialButtons {
    [self.facebookButton setState:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:facebookSocialNetwork]
                 forSocialNetwork:facebookSocialNetwork];
    self.facebookButton.tag = facebookSocialNetwork;

    [self.facebookButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.twitterButton setState:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:twitterSocialNetwork]
                forSocialNetwork:twitterSocialNetwork];

    self.twitterButton.tag = twitterSocialNetwork;
    [self.twitterButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.googleButton setState:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:googleSocialNetwork]
               forSocialNetwork:googleSocialNetwork];

    self.googleButton.tag = googleSocialNetwork;
    [self.googleButton addTarget:self action:@selector(touchedSocialNetworkButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateDatePicker:) forControlEvents:UIControlEventValueChanged];
    [self.birthdayTextField setInputView:datePicker];
}

/**
 *  Action called when the user press on a social network button
 *
 *  @param button the button
 */

- (void)touchedSocialNetworkButton:(SSORectangleSocialButton *)button {
    // Disable interactions with the button so the user can't call 2 times the same action
    if (button.isSelected) {
        // User was already
        [[SSOSocialNetworkAPI sharedInstance] usnapDisconnectToSocialNetwork:button.socialNetwork];
        [button setSelected:NO];
    } else {
        [button setUserInteractionEnabled:NO];
        [self performSelector:@selector(reEnableInteractionSocialButton:) withObject:button afterDelay:1];
        [[SSOSocialNetworkAPI sharedInstance] usnapConnectToSocialNetwork:button.socialNetwork];
        [button setSelected:[[SSOSocialNetworkAPI sharedInstance] isUsnapConnectedToSocialNetwork:button.socialNetwork]];
    }
}

/**
 *  Simple method called as selector to enable button interaction
 *
 *  @param button the social network button
 */

- (void)reEnableInteractionSocialButton:(SSOCustomSocialButton *)button {
    [button setUserInteractionEnabled:YES];
}

- (void)setUserFirstLetter:(NSString *)sender {
    if ([sender length]) {
        unichar firstChar = [[sender uppercaseString] characterAtIndex:0];
        if (firstChar >= 'A' && firstChar <= 'Z') {
            self.userFirstLetterLabel.text = [NSString stringWithFormat:@"%@", [[sender substringToIndex:1] uppercaseString]];
        }
    }
}

#pragma mark - IBActions

/**
 *  Update the datepicker textfield information
 *
 *  @param sender the datepicker
 */

- (void)updateDatePicker:(id)sender {
    if ([self.birthdayTextField isFirstResponder]) {
        UIDatePicker *picker = (UIDatePicker *)self.birthdayTextField.inputView;
        self.birthday = picker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.birthdayTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.birthday]];
    }
}

/**
 *  Prevents the user to copy and paste a wrong information
 *
 *  @param sender the textfield
 */

- (IBAction)updateBirthday:(UITextField *)sender {
    if (self.birthday) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.birthdayTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.birthday]];
    } else {
        self.birthdayTextField.text = @"";
    }
}

/**
 *  Return to the last VC
 *
 *  @param sender the button
 */

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)userChangedName:(UITextField *)sender {
    [self setUserFirstLetter:sender.text];
}

/**
 *  Open help center
 *
 *  @param sender the button
 */

- (IBAction)helpCenterAction:(UIButton *)sender {
    //@TODO
}

/**
 *  Open report a problem
 *
 *  @param sender the button
 */

- (IBAction)reportProblemAction:(UIButton *)sender {
    //@TODO
}

/**
 *  log out and remove the user information
 *
 *  @param sender the button
 */

- (IBAction)logoutAction:(UIButton *)sender {
    [[SSSessionManager sharedInstance] logoutCurrentUser];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReturnToFanPageVC object:nil userInfo:nil];
}

@end
