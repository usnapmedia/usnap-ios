//
//  SSOPhotoDetailScrollViewController.h
//  uSnap
//
//  Created by Yanick Lavoie on 2015-10-05.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOSnap.h"

@interface SSOPhotoDetailScrollViewController : UIViewController <UIScrollViewDelegate>

- (instancetype)initWithSnap:(SSOSnap *)snap andInputData:(NSMutableArray*)inputData;

@end
