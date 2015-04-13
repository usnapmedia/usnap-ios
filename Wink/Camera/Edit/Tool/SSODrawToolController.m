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
#import "UIColor+PickerColors.h"
#import <Masonry.h>

@interface SSODrawToolController () <SSOColorPickerContainerViewDelegate, SSODrawContainerViewDelegate>

#pragma mark Views

@property(strong, nonatomic) SSODrawAccessoryContainerView *accessoryContainerView;
@property(strong, nonatomic) SSOColorPickerContainerView *colorPickerContainerView;
@property(weak, nonatomic) ACEDrawingView *drawView;

@end

@implementation SSODrawToolController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the VC to the parent VC
    [self initializeContainerViewToParentVC];
}

#pragma mark - Initialization

- (void)initializeContainerViewToParentVC {
    NSAssert([self.parentViewController conformsToProtocol:@protocol(SSOEditViewControllerProtocol)],
             @"Parent view controller must conform to protocol SSOEditViewControllerProtocol");
    UIViewController<SSOEditViewControllerProtocol> *parent = (UIViewController<SSOEditViewControllerProtocol> *)self.parentViewController;

    NSAssert([parent respondsToSelector:@selector(accessoryContainerView)], @"Parent view controller must have a accessory container view");
    self.colorPickerContainerView = [NSBundle loadColorPickerContainerView];
    // Insert view to parent
    [[parent accessoryContainerView] addSubview:_colorPickerContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.colorPickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent accessoryContainerView]);
    }];
    // Set the color picker view
    self.colorPickerContainerView.delegate = self;
    self.colorPickerContainerView.colorPickerView.colors = [UIColor colorsArray];

    // Add the accessory view to the parent VC
    NSAssert([parent respondsToSelector:@selector(subtoolContainerView)], @"Parent view controller must have a subtool container view");
    self.accessoryContainerView = [NSBundle loadDrawAccessoryContainerView];
    // Insert view to parent
    [[parent subtoolContainerView] addSubview:_accessoryContainerView];
    // Set the container inside the view to have constraints on the edges
    [self.accessoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo([parent subtoolContainerView]);
    }];

    self.accessoryContainerView.delegate = self;

    NSAssert([parent respondsToSelector:@selector(drawView)], @"Parent view controller should have a draw view to draw on");
    // Set the container to the draw view delegate
    self.drawView = [parent drawView];
    self.drawView.delegate = self;
    // Set the draw view
    self.drawView.userInteractionEnabled = YES;
    self.drawView.lineColor = self.colorPickerContainerView.colorPickerView.color;
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
    // Remove the interaction on the draw view
    [self.drawView setUserInteractionEnabled:NO];
}

#pragma mark - SSOColorPickerContainerViewDelegate

- (void)colorPickerDidReset:(SSOColorPickerContainerView *)colorPickerContainerView {
    [self.drawView undoLatestStep];
}

- (void)colorPickerDidChangeColor:(SSOColorPickerContainerView *)colorPickerContainerView withColor:(UIColor *)color {
    self.drawView.lineColor = color;
}

#pragma mark - SSODrawContainerViewDelegate

- (void)drawContainer:(UIView *)view didChangePointSize:(CGFloat)lineSize {
    [self.drawView setLineWidth:lineSize];
}

- (void)containerViewDoneButtonPressed:(UIView *)view {
    [self.delegate editToolWillEndEditing:self];
}

@end
