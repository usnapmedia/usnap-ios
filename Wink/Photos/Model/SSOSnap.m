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

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"campaign_id"] isKindOfClass:[NSNull class]]){
        self.campaignId = dictionary[@"campaign_id"];
    }
    if(![dictionary[@"email"] isKindOfClass:[NSNull class]]){
        self.email = dictionary[@"email"];
    }
    if(![dictionary[@"fb_likes"] isKindOfClass:[NSNull class]]){
        self.fbLikes = dictionary[@"fb_likes"];
    }
    if(![dictionary[@"text"] isKindOfClass:[NSNull class]]){
        self.text = dictionary[@"text"];
    }
    if(![dictionary[@"thumb_url"] isKindOfClass:[NSNull class]]){
        self.thumbUrl = dictionary[@"thumb_url"];
    }
    if(![dictionary[@"url"] isKindOfClass:[NSNull class]]){
        self.url = dictionary[@"url"];
    }
    if(![dictionary[@"username"] isKindOfClass:[NSNull class]]){
        self.username = dictionary[@"username"];
    }
    if(![dictionary[@"usnap_score"] isKindOfClass:[NSNull class]]){
        self.usnapScore = dictionary[@"usnap_score"];
    }
    if(![dictionary[@"watermark_url"] isKindOfClass:[NSNull class]]){
        self.watermarkUrl = dictionary[@"watermark_url"];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.campaignId != nil){
        dictionary[@"campaign_id"] = self.campaignId;
    }
    if(self.email != nil){
        dictionary[@"email"] = self.email;
    }
    if(self.fbLikes != nil){
        dictionary[@"fb_likes"] = self.fbLikes;
    }
    if(self.text != nil){
        dictionary[@"text"] = self.text;
    }
    if(self.thumbUrl != nil){
        dictionary[@"thumb_url"] = self.thumbUrl;
    }
    if(self.url != nil){
        dictionary[@"url"] = self.url;
    }
    if(self.username != nil){
        dictionary[@"username"] = self.username;
    }
    if(self.usnapScore != nil){
        dictionary[@"usnap_score"] = self.usnapScore;
    }
    if(self.watermarkUrl != nil){
        dictionary[@"watermark_url"] = self.watermarkUrl;
    }
    return dictionary;
    
}

@end