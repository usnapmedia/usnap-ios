//
//  SSCollectionViewCell.h
//  seetynow
//
//  Created by Philippe Blondin on 2014-05-28.
//  Copyright (c) 2014 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSCollectionViewCellProtocol

@required
- (void)configureCell:(id)cellData;

@end

@interface SSCollectionViewCell : UICollectionViewCell

@end
