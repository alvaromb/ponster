//
//  PNSPostersCollectionViewController.m
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSPostersCollectionViewController.h"

@interface PNSPostersCollectionViewController ()

@property (strong, nonatomic) PNSCollectionViewDataSource *dataSource;
@property (strong, nonatomic) PNSCollectionViewDelegate *delegate;

@end

@implementation PNSPostersCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[PNSPosterCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.dataSource = [[PNSCollectionViewDataSource alloc] initWithReferenceViewController:self fetchRequest:[self fetchRequest] managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil configurationBlock:^(UICollectionViewCell *cell, id item) {
        PNSPosterCollectionViewCell *posterCell = (PNSPosterCollectionViewCell *)cell;
        [posterCell configureCellWithObject:item];
    }];
    self.collectionView.dataSource = self.dataSource;
    self.delegate = [[PNSCollectionViewDelegate alloc] initWithCellSizeBlock:^CGSize(NSIndexPath *indexPath) {
        return CGSizeMake(100, 100);
    } cellSelectionBlock:^(NSIndexPath *indexPath) {
        Poster *selectedPoster = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"cellSelectionBlock indexPath = %@", indexPath);
        PNSPosterViewController *viewController = [[PNSPosterViewController alloc] initWithPoster:selectedPoster];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    self.collectionView.delegate = self.delegate;
}

#pragma mark - NSFetchRequest

- (NSFetchRequest *)fetchRequest
{
    return [Poster MR_requestAllSortedBy:@"title"
                               ascending:YES
                               inContext:[NSManagedObjectContext MR_defaultContext]];
}

@end
