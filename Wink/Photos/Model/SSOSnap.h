#import <UIKit/UIKit.h>

@interface SSOSnap : NSObject

@property(nonatomic, strong) NSString *appId;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *fb;
@property(nonatomic, strong) NSObject *fbImageId;
@property(nonatomic, strong) NSNumber *fbLikes;
@property(nonatomic, strong) NSString *filename;
@property(nonatomic, strong) NSObject *gp;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *imageData;
@property(nonatomic, strong) NSString *meta;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSObject *text;
@property(nonatomic, strong) NSObject *tw;
@property(nonatomic, strong) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
@end