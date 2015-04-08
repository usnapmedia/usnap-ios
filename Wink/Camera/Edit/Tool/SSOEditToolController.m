//
//  SSOEditTool.m
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditToolController.h"
#import "SSOEditViewControllerProtocol.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "UnresolvedMessage"

@implementation SSOEditToolController

#pragma clang diagnostic pop

#pragma mark - View lifecycle

- (void)willMoveToParentViewController:(UIViewController<SSOEditViewControllerProtocol> *)parent {
    [super willMoveToParentViewController:parent];
    // Set the subviews if needed
    if ([parent respondsToSelector:@selector(buttonsContainerView)]) {
        self.buttonsView = [parent buttonsContainerView];
    }
    if ([parent respondsToSelector:@selector(subtoolContainerView)]) {
        self.subtoolView = [parent subtoolContainerView];
    }
    if ([parent respondsToSelector:@selector(accessoryContainerView)]) {
        self.buttonsView = [parent accessoryContainerView];
    }
    if ([parent respondsToSelector:@selector(bottomView)]) {
        self.bottomView = [parent bottomView];
    }
}

@end
