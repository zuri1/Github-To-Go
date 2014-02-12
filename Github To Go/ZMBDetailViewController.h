//
//  ZMBDetailViewController.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"

@interface ZMBDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Repo *repo;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@end
