//
//  PKPeakViewController.m
//  Paths
//
//  Created by David Mazza on 2/21/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKPeakViewController.h"

@interface PKPeakViewController ()

@end

@implementation PKPeakViewController

@synthesize mapView;

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
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView addTileSource:[[RMMapboxSource alloc] initWithMapID:@"dmzza.h26oci6o"]];
    [self.mapView setTileSourcesZoom:12.0];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.620, -74.040)];
}
- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)save:(id)sender {
    [self.delegate createNewPeakWithLocation:self.mapView.centerCoordinate assetUrl:nil street:self.streetField.text andName:self.nameField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
