//
//  SSOCampaignViewController.m
//  uSnap
//
//  Created by Marcelo De Souza on 2015-04-28.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOCampaignViewController.h"
#import <SSOSimpleTableViewProvider.h>
#import <Masonry.h>

NSString *const kCampaignTableViewCell = @"CampaignTableViewCell";
NSString *const kCampaignNibNameTableViewCell = @"SSOCampaignTableViewCell";
CGFloat const kTableViewCellHeight = 125.0f;

@interface SSOCampaignViewController ()

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SSOSimpleTableViewProvider *provider;

@end

@implementation SSOCampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUI];
    [self initializeData];
}

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
}

- (void)setCampaignData:(NSArray *)data {
    self.provider.inputData = [NSMutableArray arrayWithArray:data];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
