//
//  SSODrawTool.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSODrawToolController.h"
#import "SSOEditViewControllerProtocol.h"
#import "SSOAnimatableView.h"
#import "SSOColorPickerContainerView.h"
#import <Masonry.h>
#import <pop/POP.h>

NSString *const kColorPickerContainerViewAnimationInName = @"kColorPickerContainerViewAnimationInName";
NSString *const kColorPickerContainerViewAnimationOutName = @"kColorPickerContainerViewAnimationOutName";

@interface SSODrawToolController () <POPAnimationDelegate, SSOColorPickerContainerViewDelegate>

@property(strong, nonatomic) SSOColorPickerContainerView *colorPickerContainerView;
@property(weak, nonatomic) ACEDrawingView *drawView;

#pragma mark Animations
@property(strong, nonatomic) POPSpringAnimation *colorPickerContainerViewAnimationIn;
@property(strong, nonatomic) POPSpringAnimation *colorPickerContainerViewAnimationOut;

@end

@implementation SSODrawToolController

#pragma mark - View lifecycle

- (void)willMoveToParentViewController:(UIViewController<SSOEditViewControllerProtocol> *)parent {
    [super willMoveToParentViewController:parent];
    NSAssert([parent respondsToSelector:@selector(drawView)], @"Parent view controller should have a draw view to draw on");
    // Initialize the VC to the parent VC
    [self initializeContainerViewToParentVC:parent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAnimations];
}

#pragma mark - Initialization

- (void)initializeContainerViewToParentVC:(UIViewController<SSOEditViewControllerProtocol> *)parent {
    NSAssert([parent respondsToSelector:@selector(subtoolContainerView)], @"Parent view controller must have a subtool container view");
    self.colorPickerContainerView = [NSBundle loadColorPickerContainerView];
    // Insert view to parent
    [[parent subtoolContainerView] addSubview:_colorPickerContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.colorPickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent subtoolContainerView]);
    }];
    // Set the color picker view
    self.colorPickerContainerView.delegate = self;
    self.colorPickerContainerView.colorPickerView.colors = [UIColor colorsArray];

    // Set the container to the draw view delegate
    self.drawView = [parent drawView];
    self.drawView.delegate = self;
    // Set the draw view
    self.drawView.userInteractionEnabled = YES;
    self.drawView.lineColor = self.colorPickerContainerView.colorPickerView.color;
}

/**
 *  Initialize animations variables
 */
- (void)initializeAnimations {

    // Initialize navigation bar animation
    self.colorPickerContainerViewAnimationIn = [POPSpringAnimation animation];
    self.colorPickerContainerViewAnimationIn.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    self.colorPickerContainerViewAnimationIn.name = kColorPickerContainerViewAnimationInName;
    self.colorPickerContainerViewAnimationIn.delegate = self;
    // Move the color picker up it's size + the offset
    self.colorPickerContainerViewAnimationIn.toValue = [NSNumber numberWithFloat:1.0f];

    self.colorPickerContainerViewAnimationOut = [POPSpringAnimation animation];
    self.colorPickerContainerViewAnimationOut.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    self.colorPickerContainerViewAnimationOut.name = kColorPickerContainerViewAnimationOutName;
    self.colorPickerContainerViewAnimationOut.delegate = self;

    // Move the color picker down it's size + the offset
    self.colorPickerContainerViewAnimationOut.toValue = [NSNumber numberWithFloat:0.0f];
}

#pragma mark - SSOEditToolProtocol

- (void)displayContainerViews:(BOOL)animated {
    [self.subtoolView setHidden:NO];
    [self.subtoolView displayView:animated];
    [self.bottomView hideView:animated];
    if (animated) {
        [self.colorPickerContainerView pop_addAnimation:self.colorPickerContainerViewAnimationIn forKey:kColorPickerContainerViewAnimationInName];
    } else {
        self.colorPickerContainerView.alpha = 1.0f;
    }
}

- (void)hideContainerViews:(BOOL)animated {
    [self.subtoolView hideView:animated];
    [self.bottomView displayView:animated];
    if (animated) {
        [self.colorPickerContainerView pop_addAnimation:self.colorPickerContainerViewAnimationIn forKey:kColorPickerContainerViewAnimationInName];
    } else {
        self.colorPickerContainerView.alpha = 0.0f;
    }
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ([anim.name isEqualToString:kColorPickerContainerViewAnimationOutName]) {
        [self.colorPickerContainerView.superview setHidden:YES];
    }
}

#pragma mark - SSOColorPickerContainerViewDelegate

- (void)colorPickerDidReset:(SSOColorPickerContainerView *)colorPickerContainerView {
    [self.drawView undoLatestStep];
}

- (void)colorPickerDidChangeColor:(SSOColorPickerContainerView *)colorPickerContainerView withColor:(UIColor *)color {
    self.drawView.lineColor = color;
}

@end
