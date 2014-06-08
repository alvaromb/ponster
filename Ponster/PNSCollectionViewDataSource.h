//
//  PNSCollectionViewDataSource.h
//  Ponster
//
//  Created by Álvaro on 08/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef Class (^CollectionViewCellClass)(NSIndexPath *indexPath);
typedef void (^CollectionViewCellConfigurationBlock)(UICollectionViewCell *cell, id item);

static NSString * const cellIdentifier = @"CollectionViewCellIdentifier";

@interface PNSCollectionViewDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

@property (weak, nonatomic) UICollectionViewController *referenceViewController;

@end
