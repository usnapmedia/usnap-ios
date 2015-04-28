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
	if(![dictionary[@"app_id"] isKindOfClass:[NSNull class]]){
		self.appId = dictionary[@"app_id"];
	}	
	if(![dictionary[@"email"] isKindOfClass:[NSNull class]]){
		self.email = dictionary[@"email"];
	}	
	if(![dictionary[@"fb"] isKindOfClass:[NSNull class]]){
		self.fb = dictionary[@"fb"];
	}	
	if(![dictionary[@"fb_image_id"] isKindOfClass:[NSNull class]]){
		self.fbImageId = dictionary[@"fb_image_id"];
	}	
	if(![dictionary[@"fb_likes"] isKindOfClass:[NSNull class]]){
		self.fbLikes = dictionary[@"fb_likes"];
	}	
	if(![dictionary[@"filename"] isKindOfClass:[NSNull class]]){
		self.filename = dictionary[@"filename"];
	}	
	if(![dictionary[@"gp"] isKindOfClass:[NSNull class]]){
		self.gp = dictionary[@"gp"];
	}	
	if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
		self.id = dictionary[@"id"];
	}	
	if(![dictionary[@"image_data"] isKindOfClass:[NSNull class]]){
		self.imageData = dictionary[@"image_data"];
	}	
	if(![dictionary[@"meta"] isKindOfClass:[NSNull class]]){
		self.meta = dictionary[@"meta"];
	}	
	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}	
	if(![dictionary[@"text"] isKindOfClass:[NSNull class]]){
		self.text = dictionary[@"text"];
	}	
	if(![dictionary[@"tw"] isKindOfClass:[NSNull class]]){
		self.tw = dictionary[@"tw"];
	}	
	if(![dictionary[@"url"] isKindOfClass:[NSNull class]]){
		self.url = dictionary[@"url"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.appId != nil){
		dictionary[@"app_id"] = self.appId;
	}
	if(self.email != nil){
		dictionary[@"email"] = self.email;
	}
	if(self.fb != nil){
		dictionary[@"fb"] = self.fb;
	}
	if(self.fbImageId != nil){
		dictionary[@"fb_image_id"] = self.fbImageId;
	}
	if(self.fbLikes != nil){
		dictionary[@"fb_likes"] = self.fbLikes;
	}
	if(self.filename != nil){
		dictionary[@"filename"] = self.filename;
	}
	if(self.gp != nil){
		dictionary[@"gp"] = self.gp;
	}
	if(self.id != nil){
		dictionary[@"id"] = self.id;
	}
	if(self.imageData != nil){
		dictionary[@"image_data"] = self.imageData;
	}
	if(self.meta != nil){
		dictionary[@"meta"] = self.meta;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
	if(self.text != nil){
		dictionary[@"text"] = self.text;
	}
	if(self.tw != nil){
		dictionary[@"tw"] = self.tw;
	}
	if(self.url != nil){
		dictionary[@"url"] = self.url;
	}
	return dictionary;

}
@end