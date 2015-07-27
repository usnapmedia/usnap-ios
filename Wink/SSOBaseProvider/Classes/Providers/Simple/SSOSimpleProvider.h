//
//  SSOSimpleProvider.h
//  SSOBaseProvider
//
//  Created by Gabriel Cartier on 2015-04-21.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOProviderDelegate.h"

@interface SSOSimpleProvider : NSObject

@property(strong, nonatomic) NSMutableArray *inputData;
@property(strong, nonatomic) NSString *cellReusableIdentifier;
@property(weak, nonatomic) id<SSOProviderDelegate> delegate;

@end
