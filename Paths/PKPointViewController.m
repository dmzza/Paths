//
//  PKPointViewController.m
//  Paths
//
//  Created by David Mazza on 2/21/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKPointViewController.h"

@interface PKPointViewController ()

@end

@implementation PKPointViewController

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
	// Do any additional setup after loading the view.
    
    RMMapboxSource *onlineSource = [[RMMapboxSource alloc] initWithMapID:@"dmzza.h26oci6o"];
    
    RMMapView *mapboxView = [[RMMapView alloc] initWithFrame:self.mapView.bounds andTilesource:onlineSource];
    [self.mapView addSubview:mapboxView];
    
    [mapboxView setTileSourcesZoom:12.0];
    [mapboxView setCenterCoordinate:CLLocationCoordinate2DMake(40.620, -74.040)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
