//
//  PNSPosterViewController.m
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSPosterViewController.h"

@interface PNSPosterViewController ()

@property (strong, nonatomic) NSManagedObjectID *posterObjectID;
@property (strong, nonatomic) Poster *poster;
@property (strong, nonatomic) UIImageView *posterImageView;
@property (strong, nonatomic) UIButton *tryMeButton;
@property (strong, nonatomic) UIButton *openCVButton;

@end

@implementation PNSPosterViewController

#pragma mark - Lazy instantiation

- (UIImageView *)posterImageView
{
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc] init];
        _posterImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _posterImageView;
}

- (UIButton *)tryMeButton
{
    if (!_tryMeButton) {
        _tryMeButton = [[UIButton alloc] init];
        [_tryMeButton setTitle:@"Try me" forState:UIControlStateNormal];
        [_tryMeButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [_tryMeButton addTarget:self action:@selector(tryMeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tryMeButton;
}

- (UIButton *)openCVButton
{
    if (!_openCVButton) {
        _openCVButton = [[UIButton alloc] init];
        [_openCVButton setTitle:@"OpenCV" forState:UIControlStateNormal];
        [_openCVButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [_openCVButton addTarget:self action:@selector(openCVAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openCVButton;
}

#pragma mark - Lifecycle

- (instancetype)initWithPosterID:(NSManagedObjectID *)posterObjectID
{
    if (self = [super init]) {
        self.posterObjectID = posterObjectID;
        self.poster = (Poster *)[[NSManagedObjectContext MR_defaultContext] objectWithID:self.posterObjectID];
        self.posterImageView.image = [UIImage imageNamed:self.poster.imageUrl];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = self.poster.title;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.posterImageView];
    [self.view addSubview:self.tryMeButton];
    [self.view addSubview:self.openCVButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect bounds = self.view.bounds;
    // Poster layout
    CGSize imageSize = self.posterImageView.image.size;
    CGFloat imageWidth = ceilf((300/imageSize.height)*imageSize.width);
    self.posterImageView.frame = CGRectMake(ceilf((bounds.size.width - imageWidth)/2), 0, imageWidth, 300);
    // Try me button
    self.tryMeButton.frame = CGRectMake(40, 310, bounds.size.width - 80, 50);
    self.openCVButton.frame = CGRectMake(40, 400, bounds.size.width - 80, 50);
}

#pragma mark - Actions

- (void)tryMeAction
{
    UserDefinedTargetsViewController *viewController = [[UserDefinedTargetsViewController alloc] initWithPosterImage:self.poster.imageUrl];
    SampleAppSlidingMenuController *slidingMenuController = [[SampleAppSlidingMenuController alloc] initWithRootViewController:viewController];
    [self.navigationController pushViewController:slidingMenuController animated:YES];
}

- (void)openCVAction
{
    PNSTestViewController *viewController = [[PNSTestViewController alloc] initWithImage:self.posterImageView.image];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
