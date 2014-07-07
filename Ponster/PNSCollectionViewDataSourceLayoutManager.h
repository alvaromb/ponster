//
//  PNSCollectionViewDataSourceLayoutManager.h
//  Ponster
//
//  Created by Álvaro on 16/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSCollectionViewDataSource.h"
#import "PDKTCollectionViewWaterfallLayout.h"

typedef CGFloat (^CollectionViewWaterfallLayoutAspectRatioBlock)(NSIndexPath *indexPath, id item);

@interface PNSCollectionViewDataSourceLayoutManager : PNSCollectionViewDataSource <PDKTCollectionViewWaterfallLayoutDelegate>

- (instancetype)initWithReferenceViewController:(UICollectionViewController *)viewController
                                   fetchRequest:(NSFetchRequest *)fetchRequest
                           managedObjectContext:(NSManagedObjectContext *)context
                             sectionNameKeyPath:(NSString *)keyPath
                             configurationBlock:(CollectionViewCellConfigurationBlock)configurationBlock
                               aspectRatioBlock:(CollectionViewWaterfallLayoutAspectRatioBlock)aspectRatioBlock;

@end
