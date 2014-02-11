//
//  ZMBMenuViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZMBNetworkController.h"

@interface ZMBMenuViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSArray *searchResultsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ZMBMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.searchBar.delegate = self;
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchBarText = searchBar.text;
    self.searchResultsArray = [[ZMBNetworkController sharedController] reposForSearchString:searchBarText];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *repo = [self.searchResultsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [repo objectForKey:@"name"];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *repoDict = _searchResultsArray[indexPath.row];
//    self.detailViewController.detailItem = repoDict;
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"viewRepo"]) {
        ZMBDetailViewController *detailVC = (ZMBDetailViewController *)segue.destinationViewController;
        
        NSIndexPath *selectedItemPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *repoDict = _searchResultsArray[selectedItemPath.row];
//        detailVC.detailItem = repoDict;
        
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
