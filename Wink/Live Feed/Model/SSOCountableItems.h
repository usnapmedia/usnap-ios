#import <UIKit/UIKit.h>
#import "SSOSnap.h"

@interface SSOCountableItems : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray * response;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end