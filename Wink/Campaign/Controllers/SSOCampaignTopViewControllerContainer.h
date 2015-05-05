//
//  SSOCampaignTopViewController.h
//  uSnap
//
//  Created by Nicolas Vincensini on 2015-04-22.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWinkConnect.h"
#import <Masonry.h>
#import "SSOCampaign.h"

@protocol TopContainerFanPageDelegate;

@interface SSOCampaignTopViewControllerContainer : UIViewController

@property(weak, nonatomic) id<TopContainerFanPageDelegate> delegate;

/**
 *  Initialization
 *
 *  @param campaigns array of campaigns passes from FanPageVC
 *
 *  @return the controller
 */
- (instancetype)initWithArrayOfCampaigns:(NSArray *)campaigns;
@end

@protocol TopContainerFanPageDelegate <NSObject>

/**
 *  Delegate method returned when we change the campaign
 *
 *  @param newCampaign the new campaign
 */
- (void)topViewControllerDidChangeForNewCampaign:(SSOCampaign *)newCampaign;

@end
