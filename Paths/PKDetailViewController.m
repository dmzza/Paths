//
//  PKDetailViewController.m
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKDetailViewController.h"

@interface PKDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation PKDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    if (self.detailItem) {
        
        
        
    }
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

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        return 400;
    }
    return 320;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 80;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2; // Should be number of photos
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 0 && indexPath.row == 0) {
        PKMapTableViewCell *cell = (PKMapTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MapTableViewCell" forIndexPath:indexPath];
        
        cell.mapView.tileSource = [[RMMapBoxSource alloc] initWithMapID:@"dmzza.h26oci6o"];
        
        
        RMPolylineAnnotation *path = [[RMPolylineAnnotation alloc] initWithMapView:cell.mapView points:@[  [[CLLocation alloc] initWithLatitude:40.70478207881243 longitude:-74.01502132415771],
                                                                                                           [[CLLocation alloc] initWithLatitude:40.70624605943045 longitude:-74.0143346786499],
                                                                                                           [[CLLocation alloc] initWithLatitude:40.70662018264773 longitude:-74.01375532150269],
                                                                                                           [[CLLocation alloc] initWithLatitude:40.71831453993334 longitude:-74.0053653717041],
                                                                                                           [[CLLocation alloc] initWithLatitude:40.72203873705941 longitude:-74.00538682937622],
                                                                                                           [[CLLocation alloc] initWithLatitude:40.72977919627727 longitude:-74.00221109390259]
                                                                                                           ]];
        
        [cell.mapView addAnnotation:path];
        [cell.mapView setTileSourcesZoom:12.0];
        [cell.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.705, -73.979)];
        return cell;
    } else {
        PKPhotoTableViewCell *cell = (PKPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell" forIndexPath:indexPath];
        cell.headline.text = @"Verrazano";
        cell.subheadline.text = @"Narrows Bridge";
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        return self.pathLineView;
    }
    return nil;
}

#pragma mark - Collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PKPathMarkerCell *cell = (PKPathMarkerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MarkerCell" forIndexPath:indexPath];
    
    return cell;
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

@end
