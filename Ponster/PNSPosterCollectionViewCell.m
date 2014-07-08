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
@property (strong, nonatomic) UIImageView *posterImageView;

@end

@implementation PNSPosterCollectionViewCell

#pragma mark - Lazy instantiation

- (UILabel *)posterTitleLabel
{
    if (!_posterTitleLabel) {
        _posterTitleLabel = [[UILabel alloc] init];
        _posterTitleLabel.backgroundColor = [UIColor whiteColor];
        _posterTitleLabel.numberOfLines = 0;
        _posterTitleLabel.alpha = 0.9;
    }
    return _posterTitleLabel;
}

- (UIImageView *)posterImageView
{
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc] init];
        _posterImageView.backgroundColor = [UIColor cyanColor];
    }
    return _posterImageView;
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
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.posterImageView];
    [self.contentView addSubview:self.posterTitleLabel];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGFloat titleHeight = [self.poster.title boundingRectWithSize:CGSizeMake(bounds.size.width, 40) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.posterTitleLabel.font} context:nil].size.height;
    self.posterTitleLabel.frame = CGRectMake(0, bounds.size.height - titleHeight, bounds.size.width, titleHeight);
    self.posterImageView.frame = self.contentView.bounds;
}

#pragma mark - Cell configuration

- (void)configureCellWithObject:(id)object
{
    NSParameterAssert(object);
    NSAssert([object isKindOfClass:[Poster class]], @"Object is not of class %@", NSStringFromClass([Poster class]));

    Poster *poster = (Poster *)object;
    self.poster = poster;
    self.posterTitleLabel.text = poster.title;
    [self.posterImageView setImage:[UIImage imageNamed:self.poster.imageUrl]];
}

@end
