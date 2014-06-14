//
//  PNSCollectionViewDelegate.h
//  Ponster
//
//  Created by Álvaro on 08/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGSize (^CollectionViewCellSizeBlock)(NSIndexPath *indexPath);
typedef void (^CollectionViewCellSelectionBlock)(NSIndexPath *indexPath);

@interface PNSCollectionViewDelegate : NSObject <UICollectionViewDelegate>

- (instancetype)initWithCellSizeBlock:(CollectionViewCellSizeBlock)cellSizeBlock
                   cellSelectionBlock:(CollectionViewCellSelectionBlock)cellSelectionBlock;

@end
