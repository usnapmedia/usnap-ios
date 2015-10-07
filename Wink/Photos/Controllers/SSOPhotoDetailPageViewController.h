//
//  SSOPhotoDetailPageViewController.h
//  uSnap
//
//  Created by Yanick Lavoie on 2015-10-06.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOSnap.h"

@interface SSOPhotoDetailPageViewController : UIPageViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

- (instancetype)initWithSnap:(SSOSnap *)snap andInputData:(NSMutableArray*)inputData;

@end
