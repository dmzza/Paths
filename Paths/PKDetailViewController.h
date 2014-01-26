//
//  PKDetailViewController.h
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
#import "PKPhotoTableViewCell.h"
#import "PKMapTableViewCell.h"
#import "PKPathMarkerCell.h"

@interface PKDetailViewController : UITableViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) id detailItem;

//@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) RMMapBoxSource *tileSource;

@property (strong, nonatomic) IBOutlet UICollectionView *pathLineView;
@end
