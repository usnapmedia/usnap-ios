//
//	SSOResponse.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import "SSOCampaign.h"

@interface SSOCampaign ()
@end
@implementation SSOCampaign

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (![dictionary[@"app_id"] isKindOfClass:[NSNull class]]) {
        self.appId = dictionary[@"app_id"];
    }
    if (![dictionary[@"banner_img_url"] isKindOfClass:[NSNull class]]) {
        self.bannerImgUrl = dictionary[@"banner_img_url"];
    }
    if (![dictionary[@"description"] isKindOfClass:[NSNull class]]) {
        self.descriptionCampaign = dictionary[@"description"];
    }
    if (![dictionary[@"end_date"] isKindOfClass:[NSNull class]]) {
        self.endDate = dictionary[@"end_date"];
    }
    if (![dictionary[@"hashtags"] isKindOfClass:[NSNull class]]) {
        self.hashTags = dictionary[@"hashtags"];
    }
    if (![dictionary[@"id"] isKindOfClass:[NSNull class]]) {
        self.id = dictionary[@"id"];
    }
    if (![dictionary[@"name"] isKindOfClass:[NSNull class]]) {
        self.name = dictionary[@"name"];
    }
    if (![dictionary[@"prize"] isKindOfClass:[NSNull class]]) {
        self.prize = dictionary[@"prize"];
    }
    if (![dictionary[@"rules"] isKindOfClass:[NSNull class]]) {
        self.rules = dictionary[@"rules"];
    }
    if (![dictionary[@"start_date"] isKindOfClass:[NSNull class]]) {
        self.startDate = dictionary[@"start_date"];
    }
    if (![dictionary[@"participants"] isKindOfClass:[NSNull class]]) {
        self.participants = dictionary[@"participants"];
    }
    if (![dictionary[@"media_shared"] isKindOfClass:[NSNull class]]) {
        self.mediaShared = dictionary[@"media_shared"];
    }
    return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the
 * corresponding property
 */
- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.appId != nil) {
        dictionary[@"app_id"] = self.appId;
    }
    if (self.bannerImgUrl != nil) {
        dictionary[@"banner_img_url"] = self.bannerImgUrl;
    }
    if (self.descriptionCampaign != nil) {
        dictionary[@"description"] = self.descriptionCampaign;
    }
    if (self.endDate != nil) {
        dictionary[@"end_date"] = self.endDate;
    }
    if (self.hashTags != nil) {
        dictionary[@"hashtags"] = self.hashTags;
    }
    if (self.id != nil) {
        dictionary[@"id"] = self.id;
    }
    if (self.name != nil) {
        dictionary[@"name"] = self.name;
    }
    if (self.prize != nil) {
        dictionary[@"prize"] = self.prize;
    }
    if (self.rules != nil) {
        dictionary[@"rules"] = self.rules;
    }
    if (self.startDate != nil) {
        dictionary[@"start_date"] = self.startDate;
    }
    if (self.startDate != nil) {
        dictionary[@"participants"] = self.participants;
    }
    if (self.startDate != nil) {
        dictionary[@"media_shared"] = self.mediaShared;
    }
    return dictionary;
}
@end
