//
//  SSTableViewSection.h
//  reccard
//
//  Created by Gabriel Cartier on 2014-05-02.
//  Copyright (c) 2014 Samsao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSCellViewSection : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSMutableArray *rows;
@property(nonatomic) BOOL isSearchable;

@end
