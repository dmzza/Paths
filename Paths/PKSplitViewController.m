//
//  PKSplitViewController.m
//  Paths
//
//  Created by David Mazza on 3/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKSplitViewController.h"
#import "PKMasterViewController.h"
#import "PKPageViewController.h"

@interface PKSplitViewController ()

@end

@implementation PKSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	/*PKMasterViewController *masterViewController = [[PKMasterViewController alloc] init];
    PKPageViewController *pageViewController = [[PKPageViewController alloc] init];
    self.viewControllers = @[masterViewController, pageViewController];
    
    [self addChildViewController:masterViewController];
    [self addChildViewController:pageViewController];*/
    PKPageViewController *pageViewController = (PKPageViewController *)[self.childViewControllers lastObject];
    PKMasterViewController *masterViewController = (PKMasterViewController *)self.childViewControllers[0];
    
    masterViewController.managedObjectContext = self.managedObjectContext;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
