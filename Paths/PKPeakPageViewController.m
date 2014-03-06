//
//  PKPeakPageViewController.m
//  Paths
//
//  Created by David Mazza on 3/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKPeakPageViewController.h"

@interface PKPeakPageViewController ()

@end

@implementation PKPeakPageViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mapView = [[MKMapView alloc] init];
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.featureImageView setImage:[UIImage imageNamed:@"verrazano.png"]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*[self.mapView setTileSource:[[RMMapboxSource alloc] initWithMapID:@"dmzza.h26oci6o"]]; //hdj50i76"]];
    [self.mapView setTileSourcesZoom:16.0];
    [self.mapView setUserTrackingMode:RMUserTrackingModeFollow];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
