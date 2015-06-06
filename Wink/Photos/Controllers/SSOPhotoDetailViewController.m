//
//  SSOPhotoDetailViewController.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOPhotoDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SSORoundedBackgroundLabel.h"
#import "SSOEditSideMenuView.h"
#import "SSOFeedConnect.h"
#import "SSSessionManager.h"
#import "SSOThemeHelper.h"

@interface SSOPhotoDetailViewController ()

@property(strong, nonatomic) SSOSnap *snap;

@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UILabel *textLabel;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet SSORoundedBackgroundLabel *circledLetter;
//@property(weak, nonatomic) IBOutlet SSOEditSideMenuView *socialNetworksView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UIView *reportImageView;
@property (weak, nonatomic) IBOutlet UIButton *confirmReportButton;

@end

@implementation SSOPhotoDetailViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    // Do any additional setup after loading the view from its nib.

    self.dateLabel.hidden = YES; //@FIXME
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithSnap:(SSOSnap *)snap {

    if (self = [super init]) {
        self.snap = snap;
    }
    return self;
}

/**
 *  Set the UI of the VC
 */
- (void)setUI {

    [self setFontsAndColorsForLabels];

    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    if (self.snap) {
        NSString *firstLetter = [self.snap.email substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        self.circledLetter.text = firstLetter;
        // Check if there is a username. If not display the email (shouldn't happen because on account creation we force the username I guess)
        if (self.snap.username) {
            self.nameLabel.text = self.snap.username.uppercaseString;
        } else {
            self.nameLabel.text = self.snap.email.uppercaseString;
        }
#warning Waiting from the backend
        // We hide the date since the backend is not sending this info
        if ([self.dateLabel.text isEqualToString:@"dateLabel"]) {
            self.dateLabel.text = @"2 days ago";
        }

        self.textLabel.text = (NSString *)self.snap.text;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];

        [self.activityIndicator startAnimating];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.snap.watermarkUrl]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicator stopAnimating];
                                 }];
        [self.imageView setClipsToBounds:YES];
    }
}

/**
 *  Set the fonts and textColor properties for the labels and buttons in the view
 */
- (void)setFontsAndColorsForLabels {
    self.dateLabel.textColor = [[SSOThemeHelper firstColor] colorWithAlphaComponent:0.9];
    self.nameLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:18];
    self.dateLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:16];
    self.circledLetter.font = [SSOThemeHelper avenirHeavyFontWithSize:21];
    self.backButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:18];
    self.textLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
}

#pragma mark - IBActions

/**
 *  IBAction when pressing on back button
 *
 *  @param sender the button
 */
- (IBAction)touchedBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reportImageAction:(UIButton *)sender {
    self.reportImageView.hidden = NO;
    self.confirmReportButton.hidden = NO;
}

- (IBAction)confirmReportImageAction:(UIButton *)sender {
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"";
    }
    [SSOFeedConnect reportImageWithImageID:self.snap.url userName:user apiKey:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.reportImageView.hidden = YES;
        self.confirmReportButton.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%ld", (long)error.code] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
        self.reportImageView.hidden = YES;
        self.confirmReportButton.hidden = YES;
        
    }];
}

@end
