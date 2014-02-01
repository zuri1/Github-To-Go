//
//  ZMBGitUser.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/30/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMBGitUser : NSObject

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) UIImage *userImage;
@property (nonatomic, weak) NSOperationQueue *downloadQueue;
@property (nonatomic, readwrite) BOOL isDownloading;

- (void)downloadAvatar;

@end
