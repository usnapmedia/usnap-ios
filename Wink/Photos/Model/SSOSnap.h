#import <UIKit/UIKit.h>

@interface SSOSnap : NSObject

@property (nonatomic, strong) NSString * campaignId;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * fbLikes;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSObject * thumbUrl;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSObject * usnapScore;
@property (nonatomic, strong) NSString * watermarkUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end