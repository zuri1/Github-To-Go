//
//  ZMBMyReposViewController.h
//  Github To Go
//
//  Created by Zuri Biringer on 2/12/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMBMyReposViewController : UITableViewController 

@property (strong, nonatomic) NSFetchedResultsController *fetchedRequestsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
