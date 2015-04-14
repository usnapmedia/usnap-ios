//
//  SSOBaseTableViewProvider.m
//  Adbeus Coffee
//
//  Created by Nicolas Vincensini on 2015-01-07.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSOBaseTableViewProvider.h"

@implementation SSBaseTableViewProvider

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![[self.inputData objectAtIndex:section] isKindOfClass:[SSCellViewSection class]]) {
        // Should not happen, means it's not a proper object
        return 0;
    }
    SSCellViewSection *tableViewSection = [self.inputData objectAtIndex:section];

    return [tableViewSection.rows count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.inputData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSCellViewSection *tableViewSection = [self.inputData objectAtIndex:indexPath.section];
    SSCellViewItem *tableViewElement = [tableViewSection.rows objectAtIndex:indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:tableViewElement.cellReusableIdentifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(configureCell:)]) {
        [cell configureCell:tableViewElement.objectData];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSCellViewSection *tableViewSection = [self.inputData objectAtIndex:indexPath.section];
    SSCellViewItem *tableViewElement = [tableViewSection.rows objectAtIndex:indexPath.row];

    if (tableViewElement.cellHeight) {
        return tableViewElement.cellHeight;
    }

    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Send message to the delegate if the method is implemented
    if ([self.delegate respondsToSelector:@selector(provider:didSelectRowAtIndexPath:)]) {
        [self.delegate provider:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Send message to the delegate if the method is implemented
    if ([self.delegate respondsToSelector:@selector(provider:didDeselectRowAtIndexPath:)]) {
        [self.delegate provider:self didDeselectRowAtIndexPath:indexPath];
    }
}

@end
