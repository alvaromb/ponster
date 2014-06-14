//
//  PNSCollectionViewDelegate.m
//  Ponster
//
//  Created by Álvaro on 08/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSCollectionViewDelegate.h"

@interface PNSCollectionViewDelegate ()

@property (copy, nonatomic) CollectionViewCellSizeBlock cellSizeBlock;
@property (copy, nonatomic) CollectionViewCellSelectionBlock cellSelectionBlock;

@end

@implementation PNSCollectionViewDelegate

#pragma mark - Lifecycle

- (instancetype)initWithCellSizeBlock:(CollectionViewCellSizeBlock)cellSizeBlock
                   cellSelectionBlock:(CollectionViewCellSelectionBlock)cellSelectionBlock
{
    if (self = [super init]) {
        self.cellSizeBlock = cellSizeBlock;
        self.cellSelectionBlock = cellSelectionBlock;
    }
    return self;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellSizeBlock) {
        return self.cellSizeBlock(indexPath);
    }
    NSAssert(NO, @"You must provide a cellSizeBlock");
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellSelectionBlock) {
        self.cellSelectionBlock(indexPath);
    }
}

@end
