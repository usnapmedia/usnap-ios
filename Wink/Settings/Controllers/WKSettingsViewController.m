//
//  WKSettingsViewController.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-09-02.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import "WKSettingsViewController.h"
#import "WKSettingSocialTableViewCell.h"
#import "SSOSettingsSocialFakeTableViewCell.h"
#import "SSOSocialNetworkAPI.h"
#import "SSOGooglePlusHelper.h"

@interface WKSettingsViewController () <WKSettingsSocialCellDelegate, SocialNetworkDelegate>

// UI
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UILabel *footerLabel;
@property(weak, nonatomic) IBOutlet UIButton *contactButton;
@property(weak, nonatomic) IBOutlet UIButton *signOutButton;

@property(strong, nonatomic) SSOGooglePlusHelper *googlePlusHelper;
@property(strong, nonatomic) UISwitch *cellSwitch;

@end

@implementation WKSettingsViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.googlePlusHelper = [[SSOGooglePlusHelper alloc] init];

    [[SSOSocialNetworkAPI sharedInstance] setDelegate:self];

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
        initWithObjects:@{
            @"name" : @"Facebook",
            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kFacebookSwitchValue]],
            @"socialNetworkEnumType" : [NSNumber numberWithInteger:facebookSocialNetwork]
        },
                        @{
                            @"name" : @"Twitter",
                            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSwitchValue]],
                            @"socialNetworkEnumType" : [NSNumber numberWithInteger:twitterSocialNetwork]
                        },
                        @{
                            @"name" : @"Google+",
                            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kGooglePlusSwitchValue]],
                            @"socialNetworkEnumType" : [NSNumber numberWithInteger:googleSocialNetwork]
                        },
                        @{
                            @"name" : @"Tumblr",
                            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kTumblrSwitchValue]],
                            @"socialNetworkEnumType" : [NSNumber numberWithInteger:googleSocialNetwork]

                        },
                        @{
                            @"name" : @"Instagram",
                            @"switchValue" : [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kInstagramSwitchValue]],
                            @"socialNetworkEnumType" : [NSNumber numberWithInteger:googleSocialNetwork]

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
- (void)switchValueHasChanged:(WKSettingSocialTableViewCell *)cell withSwitch:(UISwitch *)theSwitch {
    // The object is the cell
    NSAssert([cell isKindOfClass:[UITableViewCell class]], @"Object has to be of UITableViewCell");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *socialNetwork = [[[self arraySocialNetworks] objectAtIndex:indexPath.row] valueForKey:@"name"];

    NSLog(@"cell viewWithTag 10 : %@", [cell viewWithTag:10]);

    socialNetwork = [socialNetwork stringByAppendingString:@"SwitchValue"];

    if (theSwitch.on) {
        [[SSOSocialNetworkAPI sharedInstance]
            loginWithSocialFramework:[[[[self arraySocialNetworks] objectAtIndex:indexPath.row] valueForKey:@"socialNetworkEnumType"] intValue]];
    } else {
        [[SSOSocialNetworkAPI sharedInstance]
            logoutFromSocialFramework:[[[[self arraySocialNetworks] objectAtIndex:indexPath.row] valueForKey:@"socialNetworkEnumType"] intValue]];
    }
    self.cellSwitch = theSwitch;

    // Save the social network login status
    [[NSUserDefaults standardUserDefaults] setBool:theSwitch.on forKey:socialNetwork];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self arraySocialNetworks].count;
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
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Button Actions

- (IBAction)contactButtonTouched:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"TODO"
                                message:@"TODO"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                      otherButtonTitles:nil, nil] show];
}

- (IBAction)signOutButtonTouched:(id)sender {
    [UIAlertView showWithTitle:NSLocalizedString(@"Sign Out", @"")
                       message:NSLocalizedString(@"Are you sure you would like to sign out?", @"")
             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
             otherButtonTitles:@[ NSLocalizedString(@"Sign Out", @"") ]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex){
                      }];
}

- (IBAction)doneButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SocialNetworkDelegate

/**
 *   SocialNetworkDelegate method called when a social network login by changing the switch associated to it.
 *
 *  @param socialNetwork the social network
 *  @param error         the error. Can be nil wich me login succeeded
 */
- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidFinishLoginWithError:(NSError *)error {

    if (error) {
        self.cellSwitch.on = NO;
        // Do some error handling here.
        NSLog(@"Received login error %@", error);
        if ([error code] == -1) {
            NSLog(@"Unknown error, but user probably cancelled login with Google.");
        }

    } else {
        self.cellSwitch.on = YES;
        NSLog(@" success gg with auth ");
    }
}

/**
 *  SocialNetworkDelegate method called when a social network logout by changing the switch associated to it.
 *  Actually the only socialNetwork providing a feedback on logout is Google's delegate
 *
 *  @param socialNetwork the social network
 *  @param error         the error. Can be nil wich mean logout succeeded
 */
- (void)socialNetwork:(SelectedSocialNetwork)socialNetwork DidFinishLogoutWithError:(NSError *)error {

    if (error) {
        self.cellSwitch.on = YES;
        // Do some error handling here.
        NSLog(@"Received logout error %@", error);

    } else {
        self.cellSwitch.on = NO;
        NSLog(@"Logged out with success");
    }
}

@end
