//
//  SNApplication.m
//  uSnap
//
//  Created by Yanick Lavoie on 2015-09-24.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import "SNApplication.h"
#import "SEGAnalytics.h"

@implementation SNApplication

- (void)sendEvent:(UIEvent*)event
{
    [super sendEvent:event];
    
    if (event.type != UIEventTypeTouches) {
        return;
    }
    
    UITouch *touch = ((UITouch *) (event.allTouches.allObjects)[0]);
    
    if (touch.phase != UITouchPhaseEnded) {
        return;
    }
    
    [self childsForView:touch.view];
    [self hierarchyForView:touch.view];
}


- (NSArray*)childsForView:(UIView*)view
{
    NSMutableArray *result = [@[] mutableCopy];
    if (!view) return [result copy];
    NSArray *subviews = view.subviews;
    
    for(UIView *view in subviews){
        
        if (view.accessibilityLabel.length>0) {
            NSLog(@"2:%@", view.accessibilityLabel);
            [[SEGAnalytics sharedAnalytics] track:@"Button Tapped" properties:@{@"Screen":view.accessibilityIdentifier, @"Button":view.accessibilityLabel}];
        }

//        [result addObject:@{
//                            @"label" : (view.accessibilityLabel ? view.accessibilityLabel : @""),
//                            @"identifier" : (view.accessibilityIdentifier ? view.accessibilityIdentifier : @""),
//                            @"class" : NSStringFromClass([view class])
//                            }];
    }
    
    return [result copy];
}



- (NSArray*)hierarchyForView:(UIView*)view
{
    NSMutableArray *result = [@[] mutableCopy];
    if (!view) return [result copy];
    
        if (view.accessibilityLabel.length>0) {
            NSLog(@"3:%@", view.accessibilityLabel);
            [[SEGAnalytics sharedAnalytics] track:@"Button Tapped" properties:@{@"Screen":view.accessibilityIdentifier, @"Button":view.accessibilityLabel}];
        }

    [result addObject:@{
                        @"label" : (view.accessibilityLabel ? view.accessibilityLabel : @""),
                        @"label" : (view.accessibilityLabel ? view.accessibilityLabel : @""),
                        @"identifier" : (view.accessibilityIdentifier ? view.accessibilityIdentifier : @""),
                        @"class" : NSStringFromClass([view class])
                        }];
    
    [result addObjectsFromArray:[self hierarchyForView:view.superview]];
    
    return [result copy];
}


@end
