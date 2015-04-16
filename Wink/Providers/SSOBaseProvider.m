//
//  SSOBaseProvider.m
//
//
//  Created by Gabriel Cartier on 2015-04-14.
//
//

#import "SSOBaseProvider.h"

@implementation SSOBaseProvider

#pragma mark - Utilities

- (id)objectDataAtIndexPath:(NSIndexPath *)indexPath {
    SSCellViewSection *section = [self.inputData objectAtIndex:indexPath.section];
    SSCellViewItem *row = [section.rows objectAtIndex:indexPath.row];

    return row.objectData;
}

- (SSCellViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    SSCellViewSection *section = [self.inputData objectAtIndex:indexPath.section];
    SSCellViewItem *item = [section.rows objectAtIndex:indexPath.row];

    return item;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    for (SSCellViewSection *section in self.inputData) {
        for (SSCellViewItem *item in section.rows) {
            if (item.objectData == object) {
                return [NSIndexPath indexPathForRow:[section.rows indexOfObject:item] inSection:[self.inputData indexOfObject:section]];
            }
        }
    }
    return nil;
}

@end
