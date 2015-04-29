//
//  SSOSlidingContainerView.h
//
//
//  Created by Gabriel Cartier on 2015-04-08.
//
//

#import <UIKit/UIKit.h>
#import "SSOAnimatableView.h"

@interface SSOSlidingContainerView : UIView <SSOAnimatableView>

@property CGRect viewInRect;
@property CGRect viewOutRect;

- (void)initializeAnimationWithOrientation:(UIDeviceOrientation)orientation;

@end
