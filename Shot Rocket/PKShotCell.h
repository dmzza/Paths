//
//  PKShotCell.h
//  Shot Rocket
//
//  Created by David Mazza on 8/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKShotCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *baseShotView;
@property (strong, nonatomic) IBOutlet UIImageView *middleShotView;
@property (strong, nonatomic) IBOutlet UIImageView *topShotView;

@end
