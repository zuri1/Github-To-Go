//
//  ZMBCollectionViewCell.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/30/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMBCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (readwrite, nonatomic) BOOL isDownloading;
//what does readwrite do?

@end
