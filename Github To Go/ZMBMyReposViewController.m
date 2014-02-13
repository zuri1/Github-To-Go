//
//  ZMBMyReposViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 2/12/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBMyReposViewController.h"
#import "ZMBNetworkController.h"
#import "ZMBAppDelegate.h"
#import "Repo.h"

@interface ZMBMyReposViewController () <LoginDelegate>

@property (weak, nonatomic) ZMBAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *searchResultsArray;
@property (strong, nonatomic) ZMBNetworkController *networkController;
@property (weak, nonatomic) IBOutlet UIButton *authButton;

@end

@implementation ZMBMyReposViewController

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

    self.appDelegate = (ZMBAppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _searchResultsArray = [NSMutableArray new];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
//    self.detailViewController.delegate = self;
    
    ZMBAppDelegate *appDelegate = (ZMBAppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.managedObjectContext = appDelegate.managedObjectContext;
    
    
    ZMBNetworkController *nc =[ZMBNetworkController sharedController];
    
    NSLog(@"this is the dictionary from Master view controller %@", nc.myRepoDictionary);
    
//    for (NSDictionary *dictionary in nc.myRepoDictionary)
//    {
//        [self.searchResultsArray addObject:[dictionary valueForKey:@"name"]];
//    }
    self.searchResultsArray = nc.repoArray;
    
    [self.tableView reloadData];

}

- (IBAction)authenticateButtonPressed {
    self.networkController = self.appDelegate.networkController;
    
    [self.networkController performSelector:@selector(beginOAuthAccess) withObject:nil afterDelay:.1];
    
    [self.tableView reloadData];
}

-(void)confirmLogin {
   self.authButton.hidden = YES;
    
    [self.tableView reloadData];
}

-(BOOL)authenticate {
    return self.appDelegate.authenticated;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.networkController.repoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSLog(@"tableview is drawn");
   
    cell.textLabel.text = [self.networkController.repoArray objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
