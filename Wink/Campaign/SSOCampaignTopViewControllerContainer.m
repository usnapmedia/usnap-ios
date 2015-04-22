//
//  SSOCampaignTopViewController.m
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignTopViewControllerContainer.h"

@interface SSOCampaignTopViewControllerContainer ()

@end

@implementation SSOCampaignTopViewControllerContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = NO;
    // Do any additional setup after loading the view.
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor clearColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
