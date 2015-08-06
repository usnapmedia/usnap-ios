//
//  SSBaseViewCellProtocol.h
//  Kwirk
//
//  Created by Nicolas VINCENSINI on 2014-07-30.
//  Copyright (c) 2014 Kwirk Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSBaseViewCellProtocol

@optional
- (void)willDisplayCell:(id)cellData;

@required
- (void)configureCell:(id)cellData;

@end
