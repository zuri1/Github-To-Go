//
//  ZMBMenuViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ZMBMenuViewController ()

@property (strong,nonatomic) UIViewController *topViewController;

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
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"orange"];
    [self addChildViewController:self.topViewController];
    self.topViewController.view.frame = self.view.frame;
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    
    [self addSlideGesture];
    
    [self.topViewController.view.layer setShadowOpacity:0.8];
    [self.topViewController.view.layer setShadowOffset:CGSizeMake(-8, -8)];
    [self.topViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
}

-(void)addSlideGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.topViewController.view addGestureRecognizer:pan];
    
    
}

-(void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint velocity = [pan velocityInView:self.view];
    CGPoint translation = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.topViewController.view.frame.origin.x + translation.x > 0) {
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
            
//            CGFloat offset = 1 - [(self.topViewController.view.frame.origin.x / self.view.frame.size.width)];
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 2) {
            [self openMenu];
        }
        if (self.topViewController.view.frame.origin.x < self.view.frame.size.width / 2) {
            [UIView animateWithDuration:.4 animations:^{
                self.topViewController.view.frame = self.view.frame;
            } completion:^(BOOL finished) {
                [self closeMenu];
            }];
        }
    }
    
}

-(void)openMenu
{
    [UIView animateWithDuration:1 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
        self.topViewController.view.backgroundColor = [UIColor purpleColor];
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
        [self.topViewController.view addGestureRecognizer:tap];
    }];
}

-(void)closeMenu
{
    [UIView animateWithDuration:0.2 animations:^{
        self.topViewController.view.frame = CGRectMake(self.topViewController.view.frame.origin.x + 20.f, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.topViewController.view.frame = self.view.frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.topViewController.view.frame = CGRectMake(self.topViewController.view.frame.origin.x + 15.f, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.topViewController.view.frame = self.view.frame;
                }];
            }];
        }];
    }];
}

-(void)slideBack:(id)sender
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = self.view.frame;
        self.topViewController.view.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        [self.topViewController.view removeGestureRecognizer:(UITapGestureRecognizer *)sender];
        
        [self closeMenu];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
