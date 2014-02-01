//
//  ZMBCollectionViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/30/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBCollectionViewController.h"
#import "ZMBCollectionViewCell.h"
#import "ZMBGitUser.h"

@interface ZMBCollectionViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *usersArray;
@property (strong, nonatomic) NSOperationQueue *downloadQueue;

@end

@implementation ZMBCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.searchBar.delegate = self;
    
    _downloadQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinishedNotification:) name:DOWNLOAD_NOTIFICATION object:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.searchBar.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.usersArray = [NSMutableArray new];
    
    [searchBar resignFirstResponder];
    [self searchForUser:searchBar.text];
}

- (void)searchForUser:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchString];
    
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSURL *searchURL = [NSURL URLWithString:searchString];
    
    @try {
        NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
        NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
        NSArray *searchArray = searchDictionary[@"items"];
        [self createUsersFromArray:searchArray];
    }
    @catch (NSException *exception) {
        NSLog(@"API Limit Reached? %@", exception.debugDescription);
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }
}

- (void)createUsersFromArray:(NSArray *)searchArray
{
    for (NSDictionary *dictionary in searchArray) {
        ZMBGitUser *user = [ZMBGitUser new];
        user.userName = dictionary[@"login"];
        // shorthand for objectAtKey?
        user.imageURL = dictionary[@"avatar_url"];
        user.downloadQueue = _downloadQueue;
        [self.usersArray addObject:user];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - NSNotificationCenter

- (void)downloadFinishedNotification:(NSNotification *)note
{
    id sender = [[note userInfo] objectForKey:@"user"];
    // weird...
    
    if ([sender isKindOfClass:[ZMBGitUser class]]) {
        NSLog(@"Download Finished For User: %@", sender);
        NSIndexPath *userPath = [NSIndexPath indexPathForItem:[_usersArray indexOfObject:sender] inSection:0];
        ZMBCollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:userPath];
        // ^what's going on here?
        cell.isDownloading = NO;
        [_collectionView reloadItemsAtIndexPaths:@[userPath]];
    } else {
        NSLog(@"Sender was not a GitUser");
    }
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ZMBGitUser *user = self.usersArray[indexPath.row];
    // I don't get this
    
    ZMBCollectionViewCell *customCell = (ZMBCollectionViewCell *)cell;
    customCell.userLabel.text = user.userName;
    
    if (user.userImage) {
        customCell.userImageView.image = user.userImage;
    } else {
        if (!user.isDownloading) {
            [user downloadAvatar];
            customCell.isDownloading = YES;
            customCell.backgroundColor = [UIColor redColor];
        }
    }
    
    return customCell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
