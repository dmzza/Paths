//
//  PKDetailViewController.m
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKDetailViewController.h"

@implementation PKDetailViewController

- (void)awakeFromNib
{
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        
        
        
    }
    self.photoCard.layer.cornerRadius = 5.5;
    
    RMMapboxSource *onlineSource = [[RMMapboxSource alloc] initWithMapID:@"dmzza.h26oci6o"];
    
    RMMapView *mapboxView = [[RMMapView alloc] initWithFrame:self.mapView.bounds andTilesource:onlineSource];
    [self.mapView addSubview:mapboxView];
    
    RMPolylineAnnotation *path = [[RMPolylineAnnotation alloc] initWithMapView:mapboxView points:@[  [[CLLocation alloc] initWithLatitude:40.70478207881243 longitude:-74.01502132415771],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.70624605943045 longitude:-74.0143346786499],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.70662018264773 longitude:-74.01375532150269],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.71831453993334 longitude:-74.0053653717041],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.72203873705941 longitude:-74.00538682937622],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.72977919627727 longitude:-74.00221109390259]
                                                                                                       ]];
    path.lineColor = self.photoCard.backgroundColor;
    
    [mapboxView addAnnotation:path];
    [mapboxView setTileSourcesZoom:12.0];
    //[mapboxView setCenterCoordinate:CLLocationCoordinate2DMake(40.705, -73.979)];
    [mapboxView setCenterCoordinate:CLLocationCoordinate2DMake(40.620, -74.040)];
    
    [self.streetLabel setText:@"Verrazano-Narrows Bridge"];
    [self.photoView setImage:[UIImage imageNamed:@"verrazano.png"]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
