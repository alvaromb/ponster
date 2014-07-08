//
//  PNSPostersCollectionViewController.m
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSPostersCollectionViewController.h"

@interface PNSPostersCollectionViewController ()

@property (strong, nonatomic) PNSCollectionViewDataSourceLayoutManager *dataSourceLayoutManager;
@property (strong, nonatomic) PNSCollectionViewDelegate *delegate;

@end

@implementation PNSPostersCollectionViewController

- (instancetype)init
{
    PDKTCollectionViewWaterfallLayout *waterfallLayout = [[PDKTCollectionViewWaterfallLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:waterfallLayout]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.collectionView registerClass:[PNSPosterCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        self.dataSourceLayoutManager = [[PNSCollectionViewDataSourceLayoutManager alloc] initWithReferenceViewController:self fetchRequest:[self fetchRequest] managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil configurationBlock:^(UICollectionViewCell *cell, id item) {
            PNSPosterCollectionViewCell *posterCell = (PNSPosterCollectionViewCell *)cell;
            [posterCell configureCellWithObject:item];
        } aspectRatioBlock:^CGFloat(NSIndexPath *indexPath, id item) {
            Poster *poster = (Poster *)item;
            UIImage *posterImage = [UIImage imageNamed:poster.imageUrl];
            return (157/posterImage.size.width)*posterImage.size.height;
        }];
        self.collectionView.dataSource = self.dataSourceLayoutManager;
        self.collectionView.collectionViewLayout = waterfallLayout;
        waterfallLayout.delegate = self.dataSourceLayoutManager;
        
        self.delegate = [[PNSCollectionViewDelegate alloc] initWithCellSizeBlock:^CGSize(NSIndexPath *indexPath) {
            return CGSizeMake(100, 100);
        } cellSelectionBlock:^(NSIndexPath *indexPath) {
            Poster *selectedPoster = [self.dataSourceLayoutManager.fetchedResultsController objectAtIndexPath:indexPath];
            NSLog(@"cellSelectionBlock indexPath = %@", indexPath);
            PNSPosterViewController *viewController = [[PNSPosterViewController alloc] initWithPosterID:selectedPoster.objectID];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
        self.collectionView.delegate = self.delegate;
    }
    return self;
}

#pragma mark - NSFetchRequest

- (NSFetchRequest *)fetchRequest
{
    return [Poster MR_requestAllSortedBy:@"title"
                               ascending:YES
                               inContext:[NSManagedObjectContext MR_defaultContext]];
}

@end
