//
//  PKPageViewController.m
//  Paths
//
//  Created by David Mazza on 3/1/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKPageViewController.h"
#import "PKPeakPageViewController.h"

@interface PKPageViewController ()

@end

@implementation PKPageViewController

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
	
    PKPeakPageViewController *peakVC = (PKPeakPageViewController *)[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"PeakPageViewController" ];;
    
    [self setViewControllers:@[peakVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
