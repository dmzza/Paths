//
//  PKDetailViewController.h
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>

@interface PKDetailViewController : UIViewController

@property (strong, nonatomic) NSArray *shots;
@property (strong, nonatomic) IBOutlet UIImageView *shotView;
@property (strong, nonatomic) IBOutlet UIImageView *underShotView;
@property (strong, nonatomic) IBOutlet MKMapView *shotsMap;

@end
