//
//  ZMBDetailViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBDetailViewController.h"

@interface ZMBDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ZMBDetailViewController

#pragma mark - Managing the detail item

- (void)setRepo:(Repo *)repo
{
    NSLog(@"setting detail item");
    if (_repo != repo) {
        _repo = repo;
        
        // Update the view.
        [self configureView];
    }
    


    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    
    if ([self.delegate authenticate]) {
        self.authButton.hidden = YES;
    } else {
        self.authButton.hidden = NO;
    }
}



- (void)configureView
{
    // Update the user interface for the detail item.

//    if (self.repo) {
        NSURL *htmlURL = [NSURL URLWithString:_repo.html_url];
        if (!self.repo.html_string) {
            
            self.repo.html_string = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
        }
        [_detailWebView loadHTMLString:self.repo.html_string baseURL:nil];
         //BaseURL: path to documents directory?
        NSLog(@"htmlURL: %@", htmlURL);
//    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)authButtonPressed:(id)sender {
    [self.delegate authenticateButtonPressed];
}
@end
