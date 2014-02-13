//
//  ZMBSidebarViewController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/29/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBSidebarViewController.h"
#import "ZMBMenuViewController.h"
#import "ZMBCollectionViewController.h"


@interface ZMBSidebarViewController () <UIGestureRecognizerDelegate>

@property (strong,nonatomic) UIViewController *topViewController;

@end

@implementation ZMBSidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"repoSearch"];
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    static NSString *CellIdentifier = @"Cell";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
////    
////    // Configure the cell...
////    
////    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"indexpath is %i", indexPath.row);
        
        [self.topViewController.view removeFromSuperview];
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userSearch"];
        [self addChildViewController:self.topViewController];
        self.topViewController.view.frame = self.view.frame;
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        
        [self addSlideGesture];
        
        [self.topViewController.view.layer setShadowOpacity:0.8];
        [self.topViewController.view.layer setShadowOffset:CGSizeMake(-8, -8)];
        [self.topViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        
        [self closeMenu];
    }
    if (indexPath.row == 1) {
        NSLog(@"indexpath is %i", indexPath.row);
        
        [self.topViewController.view removeFromSuperview];
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"repoSearch"];
        [self addChildViewController:self.topViewController];
        self.topViewController.view.frame = self.view.frame;
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        
        [self addSlideGesture];
        
        [self.topViewController.view.layer setShadowOpacity:0.8];
        [self.topViewController.view.layer setShadowOffset:CGSizeMake(-8, -8)];
        [self.topViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        
        [self closeMenu];
    }
    if (indexPath.row == 2) {
        [self.topViewController.view removeFromSuperview];
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myRepos"];
        [self addChildViewController:self.topViewController];
        self.topViewController.view.frame = self.view.frame;
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        
        [self addSlideGesture];
        
        [self.topViewController.view.layer setShadowOpacity:0.8];
        [self.topViewController.view.layer setShadowOffset:CGSizeMake(-8, -8)];
        [self.topViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        
        [self closeMenu];
    }
}



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
