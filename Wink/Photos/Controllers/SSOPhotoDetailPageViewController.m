//
//  SSOPhotoDetailPageViewController.m
//  uSnap
//
//  Created by Yanick Lavoie on 2015-10-06.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import "SSOPhotoDetailPageViewController.h"
#import "SSOPhotoDetailViewController.h"

@interface SSOPhotoDetailPageViewController ()
@property(strong, nonatomic) SSOSnap *snap;
@property(strong, nonatomic) NSMutableArray *inputData;
@property (assign) NSUInteger currentIndex;

@end

@implementation SSOPhotoDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
//    CGRect f = [[self view] bounds];
//    f.size.height -= 40;
//    f.origin.y = 40;
//    [[self.pageController view] setFrame:f];
    
    SSOPhotoDetailViewController *viewControllerObject = [self viewControllerAtIndex:self.currentIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:viewControllerObject];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (instancetype)initWithSnap:(SSOSnap *)snap andInputData:(NSMutableArray*)inputData {
    if (self = [super init]) {
        self.snap = snap;
        self.inputData = inputData;
        self.currentIndex = [self.inputData indexOfObject:snap];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    SSOPhotoDetailViewController *detailVC = [[SSOPhotoDetailViewController alloc] initWithSnap:self.snap andInputData:self.inputData];
//    
//    [self addChildViewController:detailVC];
//    
//    CGRect f = detailVC.view.frame;
//    f.origin.x = [UIScreen mainScreen].bounds.size.width*self.currentIndex-1;
//    detailVC.view.frame = f;
//    
//
//    [self.pageController [self viewControllerAtIndex:index];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.scrollView.contentSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width*self.inputData.count, self.scrollView.frame.size.height);
    
    
}


#pragma  - UIPageViewController Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SSOPhotoDetailViewController *)viewController indexNumber];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SSOPhotoDetailViewController *)viewController indexNumber];
    
    
    index++;
    
    if (index == self.inputData.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (SSOPhotoDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    SSOPhotoDetailViewController *childViewController = [[SSOPhotoDetailViewController alloc] initWithSnap:self.inputData[index] andInputData:self.inputData];
    childViewController.indexNumber = index;
    
    
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.currentIndex;
}

@end
