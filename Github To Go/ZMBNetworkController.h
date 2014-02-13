//
//  ZMBNetworkController.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMBNetworkController : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSMutableDictionary *myRepoDictionary;
@property (nonatomic, strong) NSMutableArray *repoArray;

+ (ZMBNetworkController *)sharedController;

- (NSMutableArray *)reposForSearchString:(NSString *)searchString;
-(void)handleCallBackURL:(NSURL *)url;
-(void)beginOAuthAccess;

@end
