//
//  ZMBMenuViewController.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMBDetailViewController.h"

@interface ZMBMenuViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ZMBDetailViewController *detailViewController;

@end
