//
//  PKMapHeaderView.h
//  Paths
//
//  Created by David Mazza on 5/19/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PKMapHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *distance;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) NSInteger section;

@end
