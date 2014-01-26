//
//  PKPhotoTableViewCell.h
//  Paths
//
//  Created by David Mazza on 1/22/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKPhotoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *headline;
@property (strong, nonatomic) IBOutlet UILabel *subheadline;

@end
