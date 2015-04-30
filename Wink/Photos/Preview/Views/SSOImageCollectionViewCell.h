//
//  imageCollectionViewCell.h
//  CustomCollectionView
//
//  Created by Nicolas Vincensini on 2015-04-02.
//  Copyright (c) 2015 Nicolas Vincensini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBaseViewCellProtocol.h"

@interface SSOImageCollectionViewCell : UICollectionViewCell<SSBaseViewCellProtocol>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
