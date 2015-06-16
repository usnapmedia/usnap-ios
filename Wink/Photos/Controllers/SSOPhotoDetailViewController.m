//
//  SSOPhotoDetailViewController.m
//  uSnap
//
//  Created by Gabriel Cartier on 2015-04-30.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOPhotoDetailViewController.h"
#import "WKMoviePlayerView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SSORoundedBackgroundLabel.h"
#import "SSOEditSideMenuView.h"
#import "SSOFeedConnect.h"
#import "SSSessionManager.h"
#import "SSOThemeHelper.h"
#import <Masonry.h>
#import <AFNetworking.h>

@interface SSOPhotoDetailViewController () <WKMoviePlayerDelegate>

@property(strong, nonatomic) SSOSnap *snap;

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) WKMoviePlayerView *moviePlayerView;

@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UILabel *textLabel;
@property(weak, nonatomic) IBOutlet SSORoundedBackgroundLabel *circledLetter;
//@property(weak, nonatomic) IBOutlet SSOEditSideMenuView *socialNetworksView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UIView *reportImageView;
@property(weak, nonatomic) IBOutlet UIButton *confirmReportButton;
@property(weak, nonatomic) IBOutlet UIButton *reportButton;

@end

@implementation SSOPhotoDetailViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPhotoVideoUI];
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

- (void)setPhotoVideoUI {
    NSString *videoURL = self.snap.videoUrl;
    if (!videoURL || [videoURL isEqualToString:@""]) {
        [self displayImage];
    } else {
        [self.confirmReportButton setTitle:@"Report this Video?" forState:UIControlStateNormal];
        [self.reportButton setTitle:@"Report Video" forState:UIControlStateNormal];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]];

        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
            progress:nil
            destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
              NSURL *documentsDirectoryURL =
                  [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
              return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            }
            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
              if (!error) {
                  [self.activityIndicator stopAnimating];
                  [self displayVideoWithPath:filePath];
              } else {
                  [self displayImage];
              }
            }];
        [downloadTask resume];
    }
}

- (void)displayVideoWithPath:(NSURL *)path {
    self.moviePlayerView = [WKMoviePlayerView moviePlayerViewWithPath:path];
    self.moviePlayerView.delegate = self;
    self.moviePlayerView.frame = self.contentView.bounds;
    self.moviePlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.moviePlayerView.clipsToBounds = YES;
    [self.contentView addSubview:self.moviePlayerView];
    [self.moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView);
    }];
    [self.moviePlayerView.player play];
}

- (void)moviePlayerViewDidFinishPlayingToEndTime:(WKMoviePlayerView *)moviePlayer {
    [self.moviePlayerView.player play];
}

- (void)displayImage {
    [self.confirmReportButton setTitle:@"Report this Image?" forState:UIControlStateNormal];
    [self.reportButton setTitle:@"Report Image" forState:UIControlStateNormal];
    self.imageView = [UIImageView new];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView);
    }];
    [self.activityIndicator startAnimating];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.snap.watermarkUrl]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               [self.activityIndicator stopAnimating];
                             }];
    [self.imageView setClipsToBounds:YES];
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
    self.reportButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
    self.confirmReportButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
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
    [SSOFeedConnect reportImageWithImageID:self.snap.url
        userName:user
        apiKey:@""
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [self.navigationController popToRootViewControllerAnimated:YES];
          self.reportImageView.hidden = YES;
          self.confirmReportButton.hidden = YES;
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:[NSString stringWithFormat:@"%ld", (long)error.code]
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil, nil];
          [errorAlert show];
          self.reportImageView.hidden = YES;
          self.confirmReportButton.hidden = YES;

        }];
}

@end
