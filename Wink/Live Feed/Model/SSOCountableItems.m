//
//	SSOCountableItems.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import "SSOCountableItems.h"

@interface SSOCountableItems ()
@end
@implementation SSOCountableItems

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (![dictionary[@"count"] isKindOfClass:[NSNull class]]) {
        self.count = [dictionary[@"count"] integerValue];
    }

    if (dictionary[@"response"] != nil && ![dictionary[@"response"] isKindOfClass:[NSNull class]]) {
        NSArray *responseDictionaries = dictionary[@"response"];
        NSMutableArray *responseItems = [NSMutableArray array];
        for (NSDictionary *responseDictionary in responseDictionaries) {
            SSOSnap *responseItem = [[SSOSnap alloc] initWithDictionary:responseDictionary];
            [responseItems addObject:responseItem];
        }
        self.response = responseItems;
    }
    return self;
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the
 * corresponding property
 */
- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"count"] = @(self.count);
    if (self.response != nil) {
        NSMutableArray *dictionaryElements = [NSMutableArray array];
        for (SSOSnap *responseElement in self.response) {
            [dictionaryElements addObject:[responseElement toDictionary]];
        }
        dictionary[@"response"] = dictionaryElements;
    }
    return dictionary;
}
@end