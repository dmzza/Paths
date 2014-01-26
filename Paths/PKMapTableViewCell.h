//
//  PKMapTableViewCell.h
//  Paths
//
//  Created by David Mazza on 1/22/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>

@interface PKMapTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet RMMapView *mapView;

@end
