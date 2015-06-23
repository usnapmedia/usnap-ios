//
//  SSOCampaignViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-28.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignViewController.h"
#import "SSOCampaign.h"
#import "SSOCampaignDetailViewController.h"
#import <SSOSimpleTableViewProvider.h>
#import <Masonry.h>

NSString *const kCampaignTableViewCell = @"CampaignTableViewCell";
NSString *const kCampaignNibNameTableViewCell = @"SSOCampaignTableViewCell";
CGFloat const kTableViewCellHeight = 125.0f;

@interface SSOCampaignViewController () <SSOProviderDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SSOSimpleTableViewProvider *provider;

@end

@implementation SSOCampaignViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUI];
    [self initializeData];
}

#pragma mark - Initialization

/**
 *  Initialize the UI
 */

- (void)initializeUI {
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:kCampaignNibNameTableViewCell bundle:nil] forCellReuseIdentifier:kCampaignTableViewCell];
    self.tableView.rowHeight = kTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initializeData {
    self.provider = [SSOSimpleTableViewProvider new];
    self.provider.cellReusableIdentifier = kCampaignTableViewCell;
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    self.provider.delegate = self;
}

#pragma mark - UI

/**
 *  The table view receive the new data and the table view is reloaded
 */

- (void)setCampaignData:(NSArray *)data {
    self.provider.inputData = [NSMutableArray arrayWithArray:data];
    [self.tableView reloadData];
}

#pragma mark - SSOProviderDelegate

- (void)provider:(id)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.provider.inputData objectAtIndex:indexPath.row] isKindOfClass:[SSOCampaign class]]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        SSOCampaignDetailViewController *detailVC =
            [[SSOCampaignDetailViewController alloc] initWithCampaign:[self.provider.inputData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


@end
