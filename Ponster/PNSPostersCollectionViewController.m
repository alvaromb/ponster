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
    self.collectionView = [[UICollectionView alloc] init];
    [self.collectionView registerClass:[PNSPosterCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.dataSource = [[PNSCollectionViewDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;
    self.delegate = [[PNSCollectionViewDelegate alloc] init];
    self.collectionView.delegate = self.delegate;
}

@end
