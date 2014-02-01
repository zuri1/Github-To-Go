//
//  ZMBCollectionViewCell.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/30/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBCollectionViewCell.h"

@interface ZMBCollectionViewCell ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation ZMBCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIsDownloading:(BOOL)isDownloading
{
    _isDownloading = isDownloading;
    // What does this do?
    
    if (isDownloading) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_activityView];
        [_activityView startAnimating];
    } else {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
