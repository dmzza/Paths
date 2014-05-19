//
//  PKThumbnailCell.h
//  Paths
//
//  Created by David Mazza on 3/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PKThumbnailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *headline;

@end