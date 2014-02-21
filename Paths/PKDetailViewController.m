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
