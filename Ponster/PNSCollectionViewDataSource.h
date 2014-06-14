//
//  PNSCollectionViewDataSource.h
//  Ponster
//
//  Created by Álvaro on 08/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef Class (^CollectionViewCellClass)(NSIndexPath *indexPath);
typedef void (^CollectionViewCellConfigurationBlock)(UICollectionViewCell *cell, id item);

static NSString * const cellIdentifier = @"CollectionViewCellIdentifier";

@interface PNSCollectionViewDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSString *sectionKeyPath;

@property (weak, nonatomic) UICollectionViewController *referenceViewController;

- (instancetype)initWithReferenceViewController:(UICollectionViewController *)viewController
                                   fetchRequest:(NSFetchRequest *)fetchRequest
                           managedObjectContext:(NSManagedObjectContext *)context
                             sectionNameKeyPath:(NSString *)keyPath
                             configurationBlock:(CollectionViewCellConfigurationBlock)configurationBlock;

@end
