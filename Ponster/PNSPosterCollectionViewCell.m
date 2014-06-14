//
//  PNSPosterCollectionViewCell.m
//  Ponster
//
//  Created by Álvaro on 08/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSPosterCollectionViewCell.h"

@interface PNSPosterCollectionViewCell ()

@property (strong, nonatomic) Poster *poster;
@property (strong, nonatomic) UILabel *posterTitleLabel;

@end

@implementation PNSPosterCollectionViewCell

#pragma mark - Lazy instantiation

- (UILabel *)posterTitleLabel
{
    if (!_posterTitleLabel) {
        _posterTitleLabel = [[UILabel alloc] init];
        _posterTitleLabel.backgroundColor = [UIColor greenColor];
        _posterTitleLabel.numberOfLines = 0;
    }
    return _posterTitleLabel;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (void)commonInitializer
{
    self.opaque = YES;
    self.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.posterTitleLabel];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.posterTitleLabel.frame = CGRectMake(5, 5, 90, 90);
}

#pragma mark - Cell configuration

- (void)configureCellWithObject:(id)object
{
    NSParameterAssert(object);
    NSAssert([object isKindOfClass:[Poster class]], @"Object is not of class %@", NSStringFromClass([Poster class]));

    Poster *poster = (Poster *)object;
    self.poster = poster;
    self.posterTitleLabel.text = poster.title;
}

@end
