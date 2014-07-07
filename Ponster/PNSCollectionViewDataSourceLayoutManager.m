//
//  PNSCollectionViewDataSourceLayoutManager.m
//  Ponster
//
//  Created by Álvaro on 16/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSCollectionViewDataSourceLayoutManager.h"

@interface PNSCollectionViewDataSourceLayoutManager ()

@property (copy, nonatomic) CollectionViewWaterfallLayoutAspectRatioBlock cellAspectRatioBlock;

@end

@implementation PNSCollectionViewDataSourceLayoutManager

#pragma mark - Lifecycle

- (instancetype)initWithReferenceViewController:(UICollectionViewController *)viewController
                                   fetchRequest:(NSFetchRequest *)fetchRequest
                           managedObjectContext:(NSManagedObjectContext *)context
                             sectionNameKeyPath:(NSString *)keyPath
                             configurationBlock:(CollectionViewCellConfigurationBlock)configurationBlock
                               aspectRatioBlock:(CollectionViewWaterfallLayoutAspectRatioBlock)aspectRatioBlock
{
    self = [super initWithReferenceViewController:viewController fetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:keyPath configurationBlock:configurationBlock];
    if (self) {
        self.cellAspectRatioBlock = aspectRatioBlock;
    }
    return self;
}

#pragma mark - <PDKTCollectionViewWaterfallLayoutDelegate>

- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout numberOfColumnsInSection:(NSUInteger)section
{
    return 2;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout aspectRatioForIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.cellAspectRatioBlock) {
//        return self.cellAspectRatioBlock(indexPath, [self.fetchedResultsController objectAtIndexPath:indexPath]);
//    }
//    return CGFLOAT_MIN;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout heightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellAspectRatioBlock) {
        return self.cellAspectRatioBlock(indexPath, [self.fetchedResultsController objectAtIndexPath:indexPath]);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout itemSpacingInSection:(NSUInteger)section
{
    return 5.0;
}

@end
