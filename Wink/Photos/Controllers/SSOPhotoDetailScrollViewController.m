//
//  SSOPhotoDetailScrollViewController.m
//  uSnap
//
//  Created by Yanick Lavoie on 2015-10-05.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import "SSOPhotoDetailScrollViewController.h"
#import "SSOPhotoDetailViewController.h"

@interface SSOPhotoDetailScrollViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) SSOSnap *snap;
@property(strong, nonatomic) NSMutableArray *inputData;
@property (assign) NSUInteger currentIndex;

@end

@implementation SSOPhotoDetailScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    SSOPhotoDetailViewController *detailVC = [[SSOPhotoDetailViewController alloc] initWithSnap:self.snap andInputData:self.inputData];
    
    [self addChildViewController:detailVC];
    
    CGRect f = detailVC.view.frame;
    f.origin.x = [UIScreen mainScreen].bounds.size.width*self.currentIndex-1;
    detailVC.view.frame = f;
    
    [self.scrollView addSubview:detailVC.view];

}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.scrollView.contentSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width*self.inputData.count, self.scrollView.frame.size.height);
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    //scrolling right
    self.currentIndex++;
    SSOPhotoDetailViewController *detailVC = [[SSOPhotoDetailViewController alloc] initWithSnap:self.inputData[self.currentIndex] andInputData:self.inputData];

    CGRect f = detailVC.view.frame;
    f.origin.x = [UIScreen mainScreen].bounds.size.width*self.currentIndex;
    detailVC.view.frame = f;
    
    [self addChildViewController:detailVC];
    [self.scrollView addSubview:detailVC.view];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
