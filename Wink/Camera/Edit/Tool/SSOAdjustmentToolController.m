//
//  SSOAdjustToolController.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-14.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOAdjustmentToolController.h"
#import "SSOAdjustementsHelper.h"
#import "SSOAdjustmentAccessoryContainerView.h"
#import "SSOAdjustmentSliderContainerView.h"
#import <Masonry.h>

@interface SSOAdjustmentToolController () <SSOAdjustmentContainerViewDelegate>

@property(strong, nonatomic) SSOAdjustmentAccessoryContainerView *accessoryContainerView;
@property(strong, nonatomic) SSOAdjustmentSliderContainerView *sliderContainerView;
@property BOOL isAdjustingBrightness;
@property(weak, nonatomic) SSOAdjustementsHelper *helper;

@end

@implementation SSOAdjustmentToolController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the VC to the parent VC
    [self initializeContainerViewToParentVC];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        // Remove oberservers
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Initialization

- (void)initializeContainerViewToParentVC {
    NSAssert([self.parentViewController conformsToProtocol:@protocol(SSOEditViewControllerProtocol)],
             @"Parent view controller must conform to protocol SSOEditViewControllerProtocol");
    UIViewController<SSOEditViewControllerProtocol> *parent = (UIViewController<SSOEditViewControllerProtocol> *)self.parentViewController;
    
    
    // Set the image helper
    NSAssert([parent respondsToSelector:@selector(adjustmentHelper)], @"Parent view controller should have an adjustment helper to apply adjustments");
    self.helper = parent.adjustmentHelper;

    NSAssert([parent respondsToSelector:@selector(accessoryContainerView)], @"Parent view controller must have a accessory container view");
    self.sliderContainerView = [[SSOAdjustmentSliderContainerView alloc] initWithFrame:[parent accessoryContainerView].frame];
    // Insert view to parent
    [[parent accessoryContainerView] addSubview:_sliderContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.sliderContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent accessoryContainerView]);
    }];

    // Set the brightness slider value by default
    [self.sliderContainerView setSliderValue:[self.helper brightnessSliderValue]];
    self.isAdjustingBrightness = YES;
    // Set the slider action
    [self.sliderContainerView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    // Add the accessory view to the parent VC
    NSAssert([parent respondsToSelector:@selector(subtoolContainerView)], @"Parent view controller must have a subtool container view");
    self.accessoryContainerView = [NSBundle loadAdjustAccessorryContainerView];
    // Insert view to parent
    [[parent subtoolContainerView] addSubview:_accessoryContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.accessoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent subtoolContainerView]);
    }];

    self.accessoryContainerView.delegate = self;
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

#pragma mark - Action

- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (self.isAdjustingBrightness) {
        [self.helper setBrightnessWithSliderValue:slider.value];
    } else {
        [self.helper setContrastWithSliderValue:slider.value];
    }
    [self.helper adjustImage];
}

#pragma mark - SSOAdjustContainerViewDelegate

- (void)containerViewDoneButtonPressed:(UIView *)view {
    [self.delegate editToolWillEndEditing:self];
}

- (void)adjustmentContainerDidPressContrast:(UIView *)view {
    self.isAdjustingBrightness = NO;
    [self.sliderContainerView setSliderValue:[self.helper contrastSliderValue]];
}

- (void)adjustmentContainerDidPressBrightness:(UIView *)view {
    self.isAdjustingBrightness = YES;
    [self.sliderContainerView setSliderValue:[self.helper brightnessSliderValue]];
}

@end
