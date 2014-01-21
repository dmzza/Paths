//
//  PKDetailViewController.h
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>

@interface PKDetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) RMMapBoxSource *tileSource;

@end
