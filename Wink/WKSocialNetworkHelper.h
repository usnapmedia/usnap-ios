//
//  WKSocialNetworkHelper.h
//  Wink
//
//  Created by Nicolas Vincensini on 2015-02-12.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKSocialNetworkHelper : NSObject

+ (void)manageConnectionToSocialNetwork:(NSString *)socialNetwork withSwitch:(UISwitch *)theSwitch;

@end
