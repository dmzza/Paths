//
//  PKPointViewController.h
//  Paths
//
//  Created by David Mazza on 2/21/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/Mapbox.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

@interface PKPointViewController : UITableViewController

@property (weak, nonatomic) IBOutlet RMMapView *mapView;

@end
