//
//  SSOOrientationHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-16.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOOrientationHelper : NSObject

@property(nonatomic) UIDeviceOrientation orientation;

+ (SSOOrientationHelper *)sharedInstance;

@end
