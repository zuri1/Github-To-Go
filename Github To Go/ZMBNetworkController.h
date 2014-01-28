//
//  ZMBNetworkController.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMBNetworkController : NSObject

+ (ZMBNetworkController *)sharedController;

- (NSArray *)reposForSearchString:(NSString *)searchString;

@end
