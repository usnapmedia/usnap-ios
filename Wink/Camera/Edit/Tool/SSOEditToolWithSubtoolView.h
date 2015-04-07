//
//  SSOEditToolWithSubtoolView.h
//  Wink
//
//  Created by Gabriel Cartier on 2015-04-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOEditTool.h"

/**
 *  Used to animate the subviews displayed
 */
@protocol SSOEditToolWithSubtoolViewProtocol <NSObject>

/**
 *  Display the subtool view
 *
 *  @param animated if animated
 */
- (void)displaySubtoolView:(BOOL)animated;

/**
 *  Hide the subtool view
 *
 *  @param animated if animated
 */
- (void)hideSubtoolView:(BOOL)animated;

@end

@interface SSOEditToolWithSubtoolView : SSOEditTool <SSOEditToolWithSubtoolViewProtocol>

/**
 *  View containing all the subtools
 */
@property(strong, nonatomic) UIView *subtoolView;

@end
