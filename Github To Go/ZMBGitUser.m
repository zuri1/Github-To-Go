//
//  ZMBGitUser.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/30/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBGitUser.h"

@implementation ZMBGitUser

- (void)downloadAvatar
{
    _isDownloading = YES;
    
    [_downloadQueue addOperationWithBlock:^{
        // Why doesn't downloadQueue have to be initialized? Is addOperationWithBlock
        // a convenience method that automatically initializes?
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]];
        _userImage = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_NOTIFICATION object:nil userInfo:@{@"user": self}];
        }];
    }];
}

@end
