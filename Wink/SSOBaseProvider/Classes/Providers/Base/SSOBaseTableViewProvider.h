//
//  SSOBaseTableViewProvider.h
//  Adbeus Coffee
//
//  Created by Nicolas Vincensini on 2015-01-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSOBaseProvider.h"

@protocol SSOBaseTableViewProviderDelegate;

@interface SSBaseTableViewProvider : SSOBaseProvider <UITableViewDelegate, UITableViewDataSource>

@end
