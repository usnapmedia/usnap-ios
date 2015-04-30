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

@interface SSOPhotoDetailViewController ()

@property(strong, nonatomic) SSOSnap *snap;

@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UILabel *textLabel;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet SSORoundedBackgroundLabel *circledLetter;
//@property(weak, nonatomic) IBOutlet SSOEditSideMenuView *socialNetworksView;

@end

@implementation SSOPhotoDetailViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    // Do any additional setup after loading the view from its nib.
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

- (void)setUI {

    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    if (self.snap) {
        NSString *firstLetter = [self.snap.email substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        self.circledLetter.text = firstLetter;
        if (self.snap.username) {
            self.nameLabel.text = self.snap.username.uppercaseString;
        } else {
            self.nameLabel.text = self.snap.email.uppercaseString;
        }
#warning Waiting from the backend
        self.dateLabel.hidden = YES;
        self.textLabel.text = (NSString *)self.snap.text;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.snap.url]];
        [self.imageView setClipsToBounds:YES];
    }
}

#pragma mark - IBActions

- (IBAction)touchedBackButton:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
