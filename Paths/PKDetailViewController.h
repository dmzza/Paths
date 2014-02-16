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

@interface PKDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (strong, nonatomic) RMMapboxSource *tileSource;
@property (strong, nonatomic) IBOutlet UIView *photoCard;
@property (strong, nonatomic) IBOutlet UILabel *streetLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;

@end
