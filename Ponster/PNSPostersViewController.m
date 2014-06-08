//
//  PNSPostersViewController.m
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSPostersViewController.h"

@interface PNSPostersViewController ()

@property (strong, nonatomic) PNSPostersCollectionViewController *childViewController;

@end

@implementation PNSPostersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.childViewController = [[PNSPostersCollectionViewController alloc] init];
    [self addChildViewController:self.childViewController];
    [self.view addSubview:self.childViewController.view];
    [self.childViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
