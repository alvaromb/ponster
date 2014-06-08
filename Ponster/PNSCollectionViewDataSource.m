//
//  PNSCollectionViewDataSource.m
//  Ponster
//
//  Created by Álvaro on 08/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSCollectionViewDataSource.h"

@interface PNSCollectionViewDataSource ()

@property (copy, nonatomic) NSMutableArray *sectionChanges;
@property (copy, nonatomic) NSMutableArray *itemChanges;

@property (copy, nonatomic) CollectionViewCellClass cellClassBlock;
@property (copy, nonatomic) CollectionViewCellConfigurationBlock cellConfigurationBlock;

@end

@implementation PNSCollectionViewDataSource

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    if (nil == cell) {
//        cell = [[self.cellClassBlock(indexPath) alloc] initWithFrame:CGRectZero collectionViewLayout:nil];
//    }
    self.cellConfigurationBlock(cell, [self.fetchedResultsController objectAtIndexPath:indexPath]);
    return cell;
}

#pragma mark - <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.referenceViewController.collectionView.window == nil) {
        return;
    }
    self.sectionChanges = [[NSMutableArray alloc] init];
    self.itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.referenceViewController.collectionView.window == nil) {
        return;
    }
    NSDictionary *changes = @{@(type): @(sectionIndex)};
    [self.sectionChanges addObject:changes];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.referenceViewController.collectionView.window == nil) {
        return;
    }
    
    NSDictionary *changes = nil;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            changes = @{@(type): newIndexPath};
            break;
        }
        case NSFetchedResultsChangeDelete|NSFetchedResultsChangeUpdate: {
            changes = @{@(type): indexPath};
            break;
        }
        case NSFetchedResultsChangeMove: {
            changes = @{@(type): @[indexPath, newIndexPath]};
            break;
        }
    }
    [self.itemChanges addObject:changes];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.referenceViewController.collectionView.window == nil) {
        [self.referenceViewController.collectionView reloadData];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.referenceViewController.collectionView performBatchUpdates:^{
        // Section changes
        for (NSDictionary *change in self.sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [weakSelf.referenceViewController.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [weakSelf.referenceViewController.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                }
            }];
        }
        
        // Item changes
        for (NSDictionary *change in self.itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [weakSelf.referenceViewController.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [weakSelf.referenceViewController.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [weakSelf.referenceViewController.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [weakSelf.referenceViewController.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        weakSelf.sectionChanges = nil;
        weakSelf.itemChanges = nil;
    }];
}

@end
