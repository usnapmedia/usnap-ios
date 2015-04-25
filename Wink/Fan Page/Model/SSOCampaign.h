//
//  SSOCampaign.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-24.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSOCampaign : NSObject

@property(nonatomic, strong) NSObject *appId;
@property(nonatomic, strong) NSString *bannerImgUrl;
@property(nonatomic, strong) NSString *descriptionCampaign;
@property(nonatomic, strong) NSString *endDate;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *prize;
@property(nonatomic, strong) NSString *rules;
@property(nonatomic, strong) NSString *startDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
@end
