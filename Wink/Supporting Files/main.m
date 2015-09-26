//
//  main.m
//  Wink
//
//  Created by Michael Hasenfratz on 2014-08-27.
//  Copyright (c) 2014 Wink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNApplication.h"
#import "WKAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([SNApplication class]), NSStringFromClass([WKAppDelegate class]));
    }
}
