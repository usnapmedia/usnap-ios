//
//  SSOCountableItems.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-24.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOCampaign.h"

@interface SSOCountableItems : NSObject

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) NSArray *response;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andClass:(Class) class;

- (NSDictionary *)toDictionary;
@end
