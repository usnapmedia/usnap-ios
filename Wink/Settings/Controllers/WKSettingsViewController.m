//
//  WKSettingsViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKSettingsViewController.h"
#import "WKUser.h"
#import "WKSettingSocialTableViewCell.h"
#import "SSOSettingsSocialFakeTableViewCell.h"
#import "WKSocialNetworkHelper.h"

@interface WKSettingsViewController () <WKSettingsSocialCellDelegate>

@end

@implementation WKSettingsViewController

#define FacebookSwitchValue [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] valueForKey:@"FacebookSwitchValue"]]

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsSocialCell" bundle:nil] forCellReuseIdentifier:@"SETTINGS_SOCIAL_CELL"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsSocialFakeCell" bundle:nil] forCellReuseIdentifier:@"SETTINGS_SOCIAL_FAKE_CELL"];

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    self.title = [NSString stringWithFormat:@"V%@", version];

    // Setup the nav bar
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor purpleTextColorWithAlpha:1.0f];

    // Setup the done button
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"").uppercaseString
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(doneButtonTouched:)];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;

    // Setup footer
    self.footerLabel.text = NSLocalizedString(@"To change your share settings, contact your Account Manager.", @"");

    NSMutableAttributedString *contactAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Contact Now", @"").uppercaseString];
    [contactAttrString addAttribute:NSKernAttributeName
                              value:[NSNumber numberWithInteger:2]
                              range:[contactAttrString.string rangeOfString:contactAttrString.string]];
    [contactAttrString addAttribute:NSForegroundColorAttributeName
                              value:[UIColor whiteColor]
                              range:[contactAttrString.string rangeOfString:contactAttrString.string]];
    [self.contactButton setAttributedTitle:contactAttrString forState:UIControlStateNormal];
    self.contactButton.layer.cornerRadius = 2.0f;
    self.contactButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.contactButton.titleLabel.minimumScaleFactor = 0.5f;

    NSMutableAttributedString *signoutAttrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Sign Out", @"").uppercaseString];
    [signoutAttrString addAttribute:NSKernAttributeName
                              value:[NSNumber numberWithInteger:2]
                              range:[signoutAttrString.string rangeOfString:signoutAttrString.string]];
    [signoutAttrString addAttribute:NSForegroundColorAttributeName
                              value:self.signOutButton.titleLabel.textColor
                              range:[signoutAttrString.string rangeOfString:signoutAttrString.string]];
    [self.signOutButton setAttributedTitle:signoutAttrString forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - Getters

/**
 *  Returns the array of social netowkr to connect for
 *
 *  @return the array
 */
- (NSArray *)arraySocialNetworks {

    NSArray *socialNetworks = [[NSArray alloc]
        initWithObjects:
            @{ @"name" : @"Facebook",
               @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]] },
            @{ @"name" : @"Twitter",
               @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSwitchValue]] },
            @{ @"name" : @"Google+",
               @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kGooglePlusSwitchValue]] },
            @{ @"name" : @"Tumblr",
               @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kTumblrSwitchValue]] },
            @{ @"name" : @"Instagram",
               @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kInstagramSwitchValue]] },

            nil];
    return socialNetworks;
}

/**
 *  Returns the array of fake social network
 *
 *  @return the array
 */
- (NSArray *)arrayFakeSocialNetworks {

    return @[ @"TAG Facebook", @"TAG Twitter", @"TAG Google+", @"TAG Tumblr", @"TAG Instagram", @"TAG Website", @"TAG Social Page" ];
}

#pragma mark - WKSettingsSocialCellDelegate

/**
 *  Called when the switch for a cell has changed.
 *
 *  @param notification the notification from the cell
 */
- (void)switchValueHasChanged:(WKSettingSocialTableViewCell *)cell withSwitch:(UISwitch *)theSwitch {
    // The object is the cell
    NSAssert([cell isKindOfClass:[UITableViewCell class]], @"Object has to be of UITableViewCell");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *socialNetwork = [[[self arraySocialNetworks] objectAtIndex:indexPath.row] valueForKey:@"name"];

    socialNetwork = [socialNetwork stringByAppendingString:@"SwitchValue"];

    [WKSocialNetworkHelper manageConnectionToSocialNetwork:socialNetwork withSwitch:theSwitch];

    // Save the social network login status
    [[NSUserDefaults standardUserDefaults] setBool:theSwitch.on forKey:socialNetwork];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Social network

- (void)setSocialNetworkUserDefaults:(NSDictionary *)socialNetwork {
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self arraySocialNetworks].count;
    } else if (section == 1) {
        return [self arrayFakeSocialNetworks].count;
    }
    // SHOULD NOT HAPPEN
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //@FIXME should not be like this
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"SETTINGS_SOCIAL_CELL";

        WKSettingSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.delegate = self;

        [cell configureCell:[[self arraySocialNetworks] objectAtIndex:indexPath.row]];
        return cell;
    } else if (indexPath.section == 1) {
        NSString *cellIdentifier = @"SETTINGS_SOCIAL_FAKE_CELL";

        SSOSettingsSocialFakeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell configureCell:[[self arrayFakeSocialNetworks] objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Button Actions

- (IBAction)contactButtonTouched:(id)sender {
    [UIAlertView showWithTitle:[WKUser currentUser].manager.phone
                       message:nil
             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
             otherButtonTitles:@[ NSLocalizedString(@"Call", @"") ]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex > 0) {
                              NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [WKUser currentUser].manager.phone]];
                              if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                                  [[UIApplication sharedApplication] openURL:phoneURL];
                              }
                          }
                      }];
}

- (IBAction)signOutButtonTouched:(id)sender {
    [UIAlertView showWithTitle:NSLocalizedString(@"Sign Out", @"")
                       message:NSLocalizedString(@"Are you sure you would like to sign out of Wink?", @"")
             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
             otherButtonTitles:@[ NSLocalizedString(@"Sign Out", @"") ]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex > 0) {
                              [WKUser logoutCurrentUser];
                          }
                      }];
}

- (IBAction)doneButtonTouched:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
