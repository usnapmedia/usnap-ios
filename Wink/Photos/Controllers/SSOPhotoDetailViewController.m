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
#import "SEGAnalytics.h"
#import "SSOPhotoDetailCommentsViewController.h"
#import <Social/Social.h>
#import "SDiPhoneVersion.h"

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
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) NSArray *loveArray;
@property (strong, nonatomic) NSArray *commentsArray;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

//@property (strong, nonatomic) UIImageView *hearthImageView;

@end

@implementation SSOPhotoDetailViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPhotoVideoUI];
    [self setUI];
    // Do any additional setup after loading the view from its nib.

    self.dateLabel.hidden = YES; //@FIXME
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.contentView addGestureRecognizer:tapGesture];

}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        self.contentView.userInteractionEnabled = NO;
        self.loveButton.userInteractionEnabled = NO;
        if (self.loveButton.selected == NO) {
            [self likeButtonAction:self.loveButton];
        }
        [self animateHearth];
    }
}

- (void)animateHearth {
    //anim a hearth just like instagram.
    UIImageView *hearthImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Heart - Active"]];
    hearthImageView.image = [hearthImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [hearthImageView setTintColor:[UIColor whiteColor]];
    hearthImageView.alpha = 0.85f;
    
    hearthImageView.layer.shadowOffset = CGSizeMake(2, 2);
    hearthImageView.layer.shadowRadius = 2.0;
    hearthImageView.layer.shadowOpacity = 0.4;
    
    hearthImageView.layer.masksToBounds = NO;
    
    
    CGRect f = hearthImageView.frame;
    f.size.height = 0;
    f.size.width = 0;
    hearthImageView.frame = f;
    hearthImageView.center = self.view.center;
    
    if (![self.view.subviews containsObject:hearthImageView]) {
        [self.view addSubview:hearthImageView];
    }
    
    
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent animations:^{
        CGRect f = hearthImageView.frame;
        f.size.height = 170;
        f.size.width = 170;
        hearthImageView.frame = f;
        hearthImageView.center = self.view.center;
    }
                     completion:^(BOOL finished) {
                         if(finished){
                             [UIView animateWithDuration:0.075f delay:0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowAnimatedContent animations:^{
                                 CGRect f = hearthImageView.frame;
                                 f.size.height = 150;
                                 f.size.width = 150;
                                 hearthImageView.frame = f;
                                 hearthImageView.center = self.view.center;
                             }
                                              completion:^(BOOL finished) {
                                                  if(finished){
                                                      [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
                                                          CGRect f = hearthImageView.frame;
                                                          f.size.height = 0;
                                                          f.size.width = 0;
                                                          hearthImageView.frame = f;
                                                          hearthImageView.center = self.view.center;
                                                      }
                                                                       completion:^(BOOL finished) {
                                                                           NSLog(@"animations complete");
                                                                           self.contentView.userInteractionEnabled = YES;
                                                                           self.loveButton.userInteractionEnabled = YES;
                                                                       }];
                                                  }
                                                  
                                              }];
                         }
                         
                     }];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"Not Logged In";
    }

    
    [SSOFeedConnect getSocialWithMediaID:self.snap.id
                             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"reponseObject %@", responseObject);
                                 self.loveArray = [[responseObject objectForKey:@"love"] objectForKey:@"users"];
                                 self.commentsArray = [[responseObject objectForKey:@"comments"] objectForKey:@"content"];
                                 
                                 
                                 NSUInteger matchingIndex = [self.loveArray indexOfObjectPassingTest:^BOOL(NSDictionary *item, NSUInteger idx, BOOL *stop) {
                                     BOOL found = [[item objectForKey:@"username"] isEqualToString:[[SSSessionManager sharedInstance] currentUsername]];
                                     return found;
                                 }];
                                 
                                 if (matchingIndex != NSNotFound) {
                                     self.loveButton.selected = YES;
                                 } else {
                                     self.loveButton.selected = NO;
                                 }
                                 
                                 self.commentButton.selected = self.commentsArray.count>0 ? YES : NO;
                                 
                            }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"error");
                            }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[SEGAnalytics sharedAnalytics] track:@"Screen Viewed" properties:@{@"Type":@"screen", @"Title":@"PhotoDetail"}];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
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
//        [self.reportButton setTitle:@"Report Video" forState:UIControlStateNormal];
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
//    [self.reportButton setTitle:@"Report Image" forState:UIControlStateNormal];
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
        if (self.snap.username) {
            NSString *firstLetter = [self.snap.username substringToIndex:1];
            firstLetter = [firstLetter uppercaseString];
            self.circledLetter.text = firstLetter;
        } else {
            [self.circledLetter setHidden:YES];
        }

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
        
        int points = [(NSString *)self.snap.usnapScore intValue];
        
        self.pointsLabel.text = [NSString stringWithFormat:@"%d %@", points, points>1?@"points":@"point"];
        [self.pointsLabel setTextColor:[SSOThemeHelper firstColor]];
        self.pointsLabel.font = [SSOThemeHelper avenirLightFontWithSize:18];

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
//    self.reportButton.titleLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:15];
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

- (IBAction)moreAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Report Image"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                              [self showConfirmationActionSheet];
                                                              NSLog(@"Report Image");
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Share to Facebook"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"fb");
                                                               [self sharefacebook];
                                                               
                                                           }];

    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Share to Twitter"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"twitter");
                                                               [self sharetwitter];
                                                           }];

    UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Delete"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {

                                                              NSLog(@"delete");
                                                          }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"cancel");
                                                           }];

    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    if ([self.snap.username isEqualToString:[[SSSessionManager sharedInstance] currentUsername]])
        [alert addAction:fourthAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) sharetwitter {
    SLComposeViewController *twitterController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [twitterController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        
        if ([self.snap.videoUrl length]>0) {
            [twitterController addURL:[NSURL URLWithString:self.snap.videoUrl]];
        } else {
            [twitterController addImage:self.imageView.image];
        }
        
        [twitterController setCompletionHandler:completionHandler];
        [self presentViewController:twitterController animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in!" message:@"Please first Sign In!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void) sharefacebook {
        SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [fbController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted....");
                    }
                        break;
                }};
            
            
            if ([self.snap.videoUrl length]>0) {
                [fbController addURL:[NSURL URLWithString:self.snap.videoUrl]];
            } else {
                [fbController addImage:self.imageView.image];
            }

            [fbController setCompletionHandler:completionHandler];
            [self presentViewController:fbController animated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in!" message:@"Please first Sign In!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
}


- (void) showConfirmationActionSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Confirm"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                              [self confirmReportImageAction:nil];
                                                          
                                                          }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"cancel");
                                                           }];
    
    
    [alert addAction:firstAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)likeButtonAction:(UIButton*)sender {

    sender.selected = !sender.selected;
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
    CGPoint center = self.loveButton.center; // or any point you want
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.loveButton.transform = t;
                         self.loveButton.center = center;
                     }
                     completion:^(BOOL finished) {
                         /* do something next */
                     }];

    
    if (sender.selected==YES) {
        self.contentView.userInteractionEnabled = NO;
        self.loveButton.userInteractionEnabled = NO;
        [self animateHearth];
    }
    
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"Not Logged In";
    }
    
    [SSOFeedConnect socialActionWithMediaID:self.snap.id
                                 actionType:@"love"
                                    content:@""
                                  userName:user
                                    apiKey:@""
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:[NSString stringWithFormat:@"%ld", (long)error.code]
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"Ok"
                                                                                  otherButtonTitles:nil, nil];
                                       [errorAlert show];

                                   }];

}
- (IBAction)loveButtonDown:(id)sender {
    CGAffineTransform t = CGAffineTransformMakeScale(1.25, 1.25);
    CGPoint center = self.loveButton.center; // or any point you want
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.loveButton.transform = t;
                         self.loveButton.center = center;
                     }
                     completion:^(BOOL finished) {
                         /* do something next */
                     }];

}

- (IBAction)loveButtonUpOutside:(id)sender {
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
    CGPoint center = self.loveButton.center; // or any point you want
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.loveButton.transform = t;
                         self.loveButton.center = center;
                     }
                     completion:^(BOOL finished) {
                         /* do something next */
                     }];
}

- (IBAction)commentButtonDown:(id)sender {

    CGAffineTransform t = CGAffineTransformMakeScale(1.25, 1.25);
    CGPoint center = self.commentButton.center; // or any point you want
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.commentButton.transform = t;
                         self.commentButton.center = center;
                     }
                     completion:^(BOOL finished) {
                         /* do something next */
                     }];

}

- (IBAction)commentButtonTouchUpOutside:(id)sender {
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
    CGPoint center = self.commentButton.center; // or any point you want
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.commentButton.transform = t;
                         self.commentButton.center = center;
                     }
                     completion:^(BOOL finished) {
                         /* do something next */
                     }];
}

- (IBAction)commentButtonAction:(UIButton*)sender {

    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
    CGPoint center = self.commentButton.center; // or any point you want
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.commentButton.transform = t;
                         self.commentButton.center = center;
                     }
                     completion:^(BOOL finished) {
                         /* do something next */
                     }];

    
    
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"Not Logged In";
    }
    
    SSOPhotoDetailCommentsViewController *commentsVC = [[SSOPhotoDetailCommentsViewController alloc] initWithNibName:@"SSOPhotoDetailCommentsViewController" bundle:nil];

    CGRect f = commentsVC.view.frame;
    CGFloat adjustedTableViewH = 0;
    CGFloat adjustedBottomConstraint = 0;
    
    switch ([SDiPhoneVersion deviceSize]) {
        case iPhone35inch:
            adjustedTableViewH = 290;
            adjustedBottomConstraint = 160;
            break;
        case iPhone4inch:
            adjustedTableViewH = 378;
            adjustedBottomConstraint = 248;
            break;
        case iPhone47inch:
            adjustedTableViewH = 487;
            adjustedBottomConstraint = 347;
            break;
        case iPhone55inch:
            adjustedTableViewH = 527;
            adjustedBottomConstraint = 406;
            break;
            
        default:
            break;
    }
    
    f.size.height = adjustedTableViewH;
    commentsVC.view.frame = f;
    commentsVC.commentsTableHeightConstraint.constant =  adjustedBottomConstraint;
    
    commentsVC.items = [NSMutableArray arrayWithArray:self.commentsArray];
    commentsVC.snap = self.snap;
    commentsVC.loved = self.loveButton.selected;
    [self.navigationController pushViewController:commentsVC animated:YES];

    
}


- (IBAction)confirmReportImageAction:(UIButton *)sender {
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"Not Logged In";
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
