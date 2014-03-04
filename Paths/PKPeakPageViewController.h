//
//  PKPeakPageViewController.h
//  Paths
//
//  Created by David Mazza on 3/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/Mapbox.h>

@interface PKPeakPageViewController : UIViewController <RMMapViewDelegate>

@property NSManagedObjectContext *managedObjectContect;

@property (strong, nonatomic) IBOutlet UIImageView *featureImageView;
@property (strong, nonatomic) IBOutlet RMMapView *mapView;

@end
