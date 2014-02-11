//
//  ZMBNetworkController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBNetworkController.h"

@implementation ZMBNetworkController

+(ZMBNetworkController *)sharedController {
    static dispatch_once_t pred;
    static ZMBNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[ZMBNetworkController alloc] init];
    });
    return shared;
}

-(NSMutableArray *)reposForSearchString:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https:api.github.com/search/repositories?q=%@", searchString];
    
    NSError *error;
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    return searchDictionary[@"items"];
}

@end
