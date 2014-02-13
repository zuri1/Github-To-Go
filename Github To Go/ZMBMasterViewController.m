//
//  ZMBMasterViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBMasterViewController.h"

#import "ZMBDetailViewController.h"
#import "ZMBNetworkController.h"
#import "Repo.h"
#import "ZMBAppDelegate.h"

@interface ZMBMasterViewController () <UISearchBarDelegate, AuthenticateButtonProtocol, LoginDelegate> {
    NSMutableArray *_objects;
}

@property (nonatomic) NSMutableArray *searchResultsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) ZMBNetworkController *networkController;
@property (weak, nonatomic) ZMBAppDelegate *appDelegate;

@end

@implementation ZMBMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.appDelegate = (ZMBAppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.delegate = self;
    
    
//    _searchResultsArray = [NSMutableArray new];
    
    self.searchBar.delegate = self;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.detailViewController = (ZMBDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];  //what does this do??
    
    self.detailViewController.delegate = self;
    
    ZMBAppDelegate *appDelegate = (ZMBAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    
    
}

-(void)confirmLogin {
    self.detailViewController.authButton.hidden = YES;
}

-(BOOL)authenticate {
    return self.appDelegate.authenticated;
}

-(void)authenticateButtonPressed {
    self.networkController = self.appDelegate.networkController;
    [self.networkController performSelector:@selector(beginOAuthAccess) withObject:nil afterDelay:.1];
}

- (IBAction)myReposBarButtonItemPressed:(id)sender {
    

    
    ZMBNetworkController *nc =[ZMBNetworkController sharedController];
    
    NSLog(@"this is the dictionary from Master view controller %@", nc.myRepoDictionary);
    
//    for (NSDictionary *dictionary in nc.myRepoDictionary) {
//        [self.searchResultsArray addObject:[dictionary valueForKey:@"name"]];
//    }
    self.searchResultsArray = nc.repoArray;
    
    [self.tableView reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSError *error;
    
    NSString *searchBarText = searchBar.text;
    self.searchResultsArray = [[ZMBNetworkController sharedController] reposForSearchString:searchBarText];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
    
    for (NSDictionary *dictionary in self.searchResultsArray) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
        Repo *repo = [[Repo alloc ] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext withJSONDictionary:dictionary];
        [repo.managedObjectContext save:&error];
    }
}



-(NSFetchedResultsController *)fetchedRequestsController
{
    if (_fetchedRequestsController) {
        
        NSLog(@"fetchedRequestController is not nil");
        return _fetchedRequestsController;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    request.entity = entityDescription;
    request.fetchBatchSize = 25;
    
    // can sort on any column
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[descriptor];  // takes an array
    self.fetchedRequestsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Repo"]; // cache name is typically model name
    
    // perform fetch
    [self.fetchedRequestsController performFetch:nil];
    
    return _fetchedRequestsController;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedRequestsController sections][section];
    NSLog(@"section info number of objects %i", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSLog(@" index path row %i", indexPath.row);
    
    Repo *repo = [self.fetchedRequestsController objectAtIndexPath:indexPath];
    cell.textLabel.text = repo.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Repo *repo = [[self fetchedRequestsController] objectAtIndexPath:indexPath];
        self.detailViewController.repo = repo;
    }
}

@end
