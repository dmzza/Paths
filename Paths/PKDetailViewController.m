//
//  PKDetailViewController.m
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKDetailViewController.h"

@implementation PKDetailViewController {
    CGPoint dragStart;
    CGPoint centerStart;
}

@synthesize mapView;

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
    //RMMapView *mapboxView = [[RMMapView alloc] initWithFrame:self.mapView.bounds];
    //[self.mapView addTileSource:[[RMMapboxSource alloc] initWithMapID:@"dmzza.h26oci6o"]]; // enablingDataOnMapView:self.mapView]];
    
    //[self.mapView addSubview:mapboxView];
    
    /*RMPolylineAnnotation *path = [[RMPolylineAnnotation alloc] initWithMapView:mapboxView points:@[  [[CLLocation alloc] initWithLatitude:40.70478207881243 longitude:-74.01502132415771],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.70624605943045 longitude:-74.0143346786499],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.70662018264773 longitude:-74.01375532150269],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.71831453993334 longitude:-74.0053653717041],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.72203873705941 longitude:-74.00538682937622],
                                                                                                       [[CLLocation alloc] initWithLatitude:40.72977919627727 longitude:-74.00221109390259]
                                                                                                       ]];
    path.lineColor = self.photoCard.backgroundColor;
    
    [mapboxView addAnnotation:path];*/
    //
    //[mapboxView setCenterCoordinate:CLLocationCoordinate2DMake(40.705, -73.979)];
    
    
    [self.streetLabel setText:@"Verrazano-Narrows Bridge"];
    [self.photoView setImage:[UIImage imageNamed:@"verrazano.png"]];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIDynamicAnimator *dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.centerAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.photoCard attachedToAnchor:self.photoCard.center];
    [self.centerAttachment setLength:0.5];
    [self.centerAttachment setFrequency:6];
    [self.centerAttachment setDamping:2];
    
    [dynamicAnimator addBehavior:self.centerAttachment];
    
    self.animator = dynamicAnimator;
    
    [self.mapView addTileSource:[[RMMapboxSource alloc] initWithMapID:@"dmzza.h26oci6o"]];
    [self.mapView setTileSourcesZoom:12.0];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.620, -74.040)];
    
    
    
    for (NSManagedObject *p in [self.fetchedPeaksController fetchedObjects]) {
        Peak *peak = (Peak *)p;
        RMPointAnnotation *pin = [RMPointAnnotation annotationWithMapView:self.mapView coordinate:CLLocationCoordinate2DMake(peak.latitude, peak.longitude) andTitle:peak.street];
        
        [self.mapView addAnnotation:pin];
    }
    
}

- (IBAction)dragCard:(UIPanGestureRecognizer *)gesture {
    CGPoint positionInWindow = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan && CGRectContainsPoint(self.photoCard.frame, positionInWindow)) {
        [self.animator removeBehavior:self.centerAttachment];
        dragStart = [gesture locationInView:self.view];
        centerStart = self.photoCard.center;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.animator addBehavior:self.centerAttachment];
    } else {
        CGPoint newCenter = CGPointMake(positionInWindow.x - dragStart.x + centerStart.x, positionInWindow.y - dragStart.y + centerStart.y);
        
        [self.photoCard setCenter:newCenter];
    }
}

# pragma mark - Peak VC Delegate

- (void)createNewPeakWithLocation:(CLLocationCoordinate2D)aLocation assetUrl:(NSString *)aUrl street:(NSString *)aStreet andName:(NSString *)aName
{
    NSManagedObjectContext *context = [self.fetchedPeaksController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedPeaksController fetchRequest] entity];
    Peak *newPeak = (Peak *)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    newPeak.latitude = aLocation.latitude;
    newPeak.longitude = aLocation.longitude;
    newPeak.street = aStreet;
    newPeak.name = aName;
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"Peak Saved");
        }
    }];
}

# pragma mark - Map View Delegate



# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"peakSegue"]) {
        [(PKPeakViewController *)[[segue destinationViewController] topViewController] setDelegate:self];
    }
}

# pragma mark - Data

- (NSFetchedResultsController *)fetchedPeaksController {
    if (_fetchedPeaksController != nil) {
        return _fetchedPeaksController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Peak" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"longitude" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedPeaksController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"PathPeaks"];
    aFetchedPeaksController.delegate = self;
    self.fetchedPeaksController = aFetchedPeaksController;
    
	NSError *error = nil;
	if (![self.fetchedPeaksController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedPeaksController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.mapView removeAllAnnotations];
    for (NSManagedObject *p in [self.fetchedPeaksController fetchedObjects]) {
        Peak *peak = (Peak *)p;
        RMPointAnnotation *pin = [RMPointAnnotation annotationWithMapView:self.mapView coordinate:CLLocationCoordinate2DMake(peak.latitude, peak.longitude) andTitle:peak.street];
        
        [self.mapView addAnnotation:pin];
    }
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
