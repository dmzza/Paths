//
//  PKZoomingFlowLayout.h
//  Shot Rocket
//
//  Created by David Mazza on 9/1/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKZoomingFlowLayout : UICollectionViewFlowLayout

/// The default resistance factor that determines the bounce of the collection. Default is 900.0f.
#define kScrollResistanceFactorDefault 900.0f;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
/// The scrolling resistance factor determines how much bounce / resistance the collection has. A higher number is less bouncy, a lower number is more bouncy. The default is 900.0f.
@property (nonatomic, assign) CGFloat scrollResistanceFactor;
@property (nonatomic, strong) NSIndexPath *pinchedItem;
@property (nonatomic) CGSize pinchedItemSize;
@property (nonatomic, strong) NSIndexPath *draggedItem;
@property (nonatomic) CGPoint draggedTo;
@property (nonatomic, strong) NSIndexPath *scaledItem;
@property (nonatomic) CGFloat scaleFactor;

- (void)resizeItemAtIndexPath:(NSIndexPath*)indexPath withPinchDistance:(CGFloat)distance;
- (void)scaleItemAtIndexPath:(NSIndexPath*)indexPath withScaleFactor:(CGFloat)scale;
- (void)translateItemAtIndexPath:(NSIndexPath *)indexPath withTranslation:(CGPoint)translation;

@end
