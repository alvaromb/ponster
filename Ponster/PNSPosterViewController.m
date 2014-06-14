//
//  PNSPosterViewController.m
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSPosterViewController.h"

@interface PNSPosterViewController ()

@property (strong, nonatomic) Poster *poster;

@end

@implementation PNSPosterViewController

- (instancetype)initWithPoster:(Poster *)poster
{
    if (self = [super init]) {
        self.poster = poster;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.poster.title;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"Poster %@", self.poster);
}

@end
