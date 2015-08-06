//
//	SSOResponse.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import "SSOSnap.h"

@interface SSOSnap ()
@end
@implementation SSOSnap

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (![dictionary[@"campaign_id"] isKindOfClass:[NSNull class]]) {
        self.campaignId = dictionary[@"campaign_id"];
    }
    if (![dictionary[@"email"] isKindOfClass:[NSNull class]]) {
        self.email = dictionary[@"email"];
    }
    if (![dictionary[@"fb_likes"] isKindOfClass:[NSNull class]]) {
        self.fbLikes = dictionary[@"fb_likes"];
    }
    if (![dictionary[@"id"] isKindOfClass:[NSNull class]]) {
        self.id = dictionary[@"id"];
    }
    if (![dictionary[@"text"] isKindOfClass:[NSNull class]]) {
        self.text = dictionary[@"text"];
    }
    if (![dictionary[@"thumb_url"] isKindOfClass:[NSNull class]]) {
        self.thumbUrl = dictionary[@"thumb_url"];
    }
    if (![dictionary[@"cloud_url"] isKindOfClass:[NSNull class]]) {
        self.cloudUrl = dictionary[@"cloud_url"];
    }
    if (![dictionary[@"url"] isKindOfClass:[NSNull class]]) {
        self.url = dictionary[@"url"];
    }
    if (![dictionary[@"username"] isKindOfClass:[NSNull class]]) {
        self.username = dictionary[@"username"];
    }
    if (![dictionary[@"usnap_score"] isKindOfClass:[NSNull class]]) {
        self.usnapScore = dictionary[@"usnap_score"];
    }
    if (![dictionary[@"video_url"] isKindOfClass:[NSNull class]]) {
        self.videoUrl = dictionary[@"video_url"];
    }
    if (![dictionary[@"watermark_url"] isKindOfClass:[NSNull class]]) {
        self.watermarkUrl = dictionary[@"watermark_url"];
    }
    return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the
 * corresponding property
 */

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.campaignId != nil) {
        dictionary[@"campaign_id"] = self.campaignId;
    }
    if (self.email != nil) {
        dictionary[@"email"] = self.email;
    }
    if (self.fbLikes != nil) {
        dictionary[@"fb_likes"] = self.fbLikes;
    }
    if (self.id != nil) {
        dictionary[@"id"] = self.id;
    }
    if (self.text != nil) {
        dictionary[@"text"] = self.text;
    }
    if (self.thumbUrl != nil) {
        dictionary[@"thumb_url"] = self.thumbUrl;
    }
    if (self.cloudUrl != nil) {
        dictionary[@"cloud_url"] = self.cloudUrl;
    }
    if (self.url != nil) {
        dictionary[@"url"] = self.url;
    }
    if (self.username != nil) {
        dictionary[@"username"] = self.username;
    }
    if (self.usnapScore != nil) {
        dictionary[@"usnap_score"] = self.usnapScore;
    }
    if (self.videoUrl != nil) {
        dictionary[@"video_url"] = self.videoUrl;
    }
    if (self.watermarkUrl != nil) {
        dictionary[@"watermark_url"] = self.watermarkUrl;
    }
    return dictionary;
}

- (NSString *) thumbUrl:(long) width height:(long) height {
    NSString * url = self.cloudUrl;
    if ([url containsString:@".mp4"]) {
        url = [url stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"];
    }
    
    width = (width>0?width:300);
    height = (height>0?height:300);
    if (IS_RETINA) {
        width = width * [UIScreen mainScreen].scale;
        height = height * [UIScreen mainScreen].scale;
    }
    
    return [url stringByReplacingOccurrencesOfString:@"upload/"
                                          withString:[NSString stringWithFormat:@"upload/w_%ld,h_%ld,c_fill,g_face/", width, height]];
}

@end