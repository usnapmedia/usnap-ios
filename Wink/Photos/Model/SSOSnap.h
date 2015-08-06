#import <UIKit/UIKit.h>

@interface SSOSnap : NSObject

@property (nonatomic, strong) NSString * campaignId;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * fbLikes;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * thumbUrl;
@property (nonatomic, strong) NSString * cloudUrl;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSObject * usnapScore;
@property (nonatomic, strong) NSString * videoUrl;
@property (nonatomic, strong) NSString * watermarkUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

- (NSString *) thumbUrl:(long) width height:(long) height;
@end