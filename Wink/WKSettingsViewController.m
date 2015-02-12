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

@interface WKSettingsViewController () <WKSettingsSocialCellDelegate>

@end

@implementation WKSettingsViewController

#define FacebookSwitchValue [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] valueForKey:@"FacebookSwitchValue"]]

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSocialCell" bundle:nil] forCellReuseIdentifier:@"SETTINGS_SOCIAL_CELL"];

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

- (NSArray *)arraySocialNetworks {

    NSArray *socialNetworks = [[NSArray alloc]
        initWithObjects:@{
            @"name" : @"Facebook",
            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:FACEBOOK_SWITCH_VALUE]]
        },
                        @{
                            @"name" : @"Twitter",
                            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:TWITTER_SWITCH_VALUE]]
                        },
                        nil];
    return socialNetworks;
}

#pragma mark - WKSettingsSocialCellDelegate

/**
 *  Called when the switch for a cell has changed.
 *
 *  @param notification the notification from the cell
 */
- (void)switchValueHasChanged:(WKSettingSocialTableViewCell *)cell withSwitchValue:(BOOL)switchValue {
    // The object is the cell
    NSAssert([cell isKindOfClass:[UITableViewCell class]], @"Object has to be of UITableViewCell");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *socialNetwork = [[[self arraySocialNetworks] objectAtIndex:indexPath.row] valueForKey:@"name"];

    socialNetwork = [socialNetwork stringByAppendingString:@"SwitchValue"];

    NSLog(@"socialNetwork : %@", socialNetwork);

    [[NSUserDefaults standardUserDefaults] setBool:switchValue forKey:socialNetwork];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Social network

- (void)setSocialNetworkUserDefaults:(NSDictionary *)socialNetwork {
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self arraySocialNetworks].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"SETTINGS_SOCIAL_CELL";

    WKSettingSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;

    [cell configureCell:[[self arraySocialNetworks] objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell isKindOfClass:[WKSettingSocialTableViewCell class]]) {
        WKSettingSocialTableViewCell *myCell = (WKSettingSocialTableViewCell *)cell;
    } else {
        NSDictionary *networkDict = [[WKUser currentUser].socialNetworks objectAtIndex:indexPath.row];
        NSString *key = networkDict.allKeys.lastObject;
        BOOL enabled = [[networkDict objectForKey:key] boolValue];

        UIColor *textColor = (enabled) ? [UIColor purpleTextColorWithAlpha:1.0f] : [UIColor lightGreyTextColorWithAlpha:1.0f];

        cell.textLabel.font = [UIFont winkFontAvenirWithSize:19.0f];
        cell.textLabel.textColor = textColor;
        cell.textLabel.text = key.capitalizedString;

        cell.detailTextLabel.font = [UIFont winkFontAvenirWithSize:19.0f];
        cell.detailTextLabel.textColor = textColor;
        cell.detailTextLabel.text = (enabled) ? NSLocalizedString(@"On", @"").uppercaseString : NSLocalizedString(@"Off", @"").uppercaseString;
    }
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
