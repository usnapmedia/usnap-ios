//
//  SSOCameraViewController.m
//  Wink
//
//  Created by Justin Khan on 2015-03-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCameraViewController.h"
#import "SSOContainerViewController.h"

@interface SSOCameraViewController ()

// IBOutlets
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *videoCenteringConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *photoCenteringConstraint;
@property(weak, nonatomic) IBOutlet UIButton *photoButton;
@property(weak, nonatomic) IBOutlet UIButton *videoButton;

// View Controllers
@property(weak, nonatomic) SSOContainerViewController *containerViewController;

// Data

@end

@implementation SSOCameraViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Utilities

/**
 *  Animate the photo and video buttons positions
 */
- (void)animatePhotoVideoSwitch {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{ [self.view layoutIfNeeded]; }
                     completion:nil];
}

- (void)swapPhotoAndVideoButtonsWithButtonToCenter:(UIButton *)buttonToCenter
                            andCenteringConstraint:(NSLayoutConstraint *)constraintToCenter
                               andConstraintToMove:(NSLayoutConstraint *)constraintToShift
                            withLeftwardsDirection:(BOOL)isMovingLeftwards {
    // Shift photo button to the left and move video button to the center
    float widthOfButtonToCenter = buttonToCenter.frame.size.width;
    float widthOfScreenMinusButtonToCenter = kScreenSize.width / 2 - widthOfButtonToCenter / 2;

    if (isMovingLeftwards) {
        constraintToShift.constant = widthOfScreenMinusButtonToCenter / 2 + widthOfButtonToCenter / 2;
    } else {
        constraintToShift.constant = -(widthOfScreenMinusButtonToCenter / 2 + widthOfButtonToCenter / 2);
    }
    constraintToCenter.constant = 0;

    // Animate the photo and video buttons positions
    [self animatePhotoVideoSwitch];
}

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Set up container view controller
    if ([segue.identifier isEqualToString:kCameraContainerSegue]) {
        SSOContainerViewController *containerViewController = (SSOContainerViewController *)segue.destinationViewController;

        [containerViewController setInitialViewController:PhotoContainerCamera];

        // Store the container view controller in a property to be used to swap view controller
        self.containerViewController = containerViewController;
    }
}

#pragma mark - IBActions

- (IBAction)photoContainerButtonPushed:(id)sender {
    [self.containerViewController swapToViewControllerOfType:PhotoContainerCamera];

    [self swapPhotoAndVideoButtonsWithButtonToCenter:self.photoButton
                              andCenteringConstraint:self.photoCenteringConstraint
                                 andConstraintToMove:self.videoCenteringConstraint
                              withLeftwardsDirection:NO];
}

- (IBAction)videoContainerButtonPushed:(id)sender {
    [self.containerViewController swapToViewControllerOfType:VideoContainerCamera];

    [self swapPhotoAndVideoButtonsWithButtonToCenter:self.videoButton
                              andCenteringConstraint:self.videoCenteringConstraint
                                 andConstraintToMove:self.photoCenteringConstraint
                              withLeftwardsDirection:YES];
}

@end
