//
//  PKZoomingFlowLayout.h
//  Shot Rocket
//
//  Created by David Mazza on 9/1/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKZoomingFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *pinchedItem;
@property (nonatomic) CGSize pinchedItemSize;

- (void)resizeItemAtIndexPath:(NSIndexPath*)indexPath withPinchDistance:(CGFloat)distance;

@end
