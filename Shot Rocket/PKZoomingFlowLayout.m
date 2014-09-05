//
//  PKZoomingFlowLayout.m
//  Shot Rocket
//
//  Created by David Mazza on 9/1/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKZoomingFlowLayout.h"

@interface PKZoomingFlowLayout ()

// Needed for tiling
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, strong) NSMutableSet *visibleHeaderAndFooterSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;

@end

@implementation PKZoomingFlowLayout


- (void)awakeFromNib
{
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _visibleIndexPathsSet = [NSMutableSet set];
    _visibleHeaderAndFooterSet = [[NSMutableSet alloc] init];
    _pinchedItem = 0;
    _pinchedItemSize = CGSizeMake(320, 568);
    _scaledItem = 0;
    _scaleFactor = 1.0;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if ([[UIApplication sharedApplication] statusBarOrientation] != self.interfaceOrientation) {
        [self.dynamicAnimator removeAllBehaviors];
        self.visibleIndexPathsSet = [NSMutableSet set];
    }
    
    self.interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    // Step 1: Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        return [itemsIndexPathsInVisibleRectSet containsObject:[[[behaviour items] firstObject] indexPath]] == NO;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
        [self.visibleHeaderAndFooterSet removeObject:[[[obj items] firstObject] indexPath]];
    }];
    
    // Step 2: Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        return (item.representedElementCategory == UICollectionElementCategoryCell ?
                [self.visibleIndexPathsSet containsObject:item.indexPath] : [self.visibleHeaderAndFooterSet containsObject:item.indexPath]) == NO;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 1.0f;
        springBehaviour.damping = 0.8f;
        springBehaviour.frequency = 1.0f;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
                
                CGFloat scrollResistance;
                if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
                else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
                
                if (self.latestDelta < 0) center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
                else center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
                
                item.center = center;
                
            } else {
                CGFloat distanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
                
                CGFloat scrollResistance;
                if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
                else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
                
                if (self.latestDelta < 0) center.x += MAX(self.latestDelta, self.latestDelta*scrollResistance);
                else center.x += MIN(self.latestDelta, self.latestDelta*scrollResistance);
                
                item.center = center;
            }
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        if(item.representedElementCategory == UICollectionElementCategoryCell)
        {
            [self.visibleIndexPathsSet addObject:item.indexPath];
        }
        else
        {
            [self.visibleHeaderAndFooterSet addObject:item.indexPath];
        }
    }];
}


- (UICollectionViewScrollDirection)scrollDirection
{
    return UICollectionViewScrollDirectionVertical;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *dynamicLayoutAttributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    // Check if dynamic animator has layout attributes for a layout, otherwise use the flow layouts properties. This will prevent crashing when you add items later in a performBatchUpdates block (e.g. triggered by NSFetchedResultsController update)
    return (dynamicLayoutAttributes)?dynamicLayoutAttributes:[super layoutAttributesForItemAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    
    CGFloat delta;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) delta = newBounds.origin.y - scrollView.bounds.origin.y;
    else delta = newBounds.origin.x - scrollView.bounds.origin.x;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            
            CGFloat scrollResistance;
            if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
            else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
            
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            CGPoint center = item.center;
            if (delta < 0) center.y += MAX(delta, delta*scrollResistance);
            else center.y += MIN(delta, delta*scrollResistance);
            
            item.center = center;
            
            [self.dynamicAnimator updateItemUsingCurrentState:item];
        } else {
            CGFloat distanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
            
            CGFloat scrollResistance;
            if (self.scrollResistanceFactor) scrollResistance = distanceFromTouch / self.scrollResistanceFactor;
            else scrollResistance = distanceFromTouch / kScrollResistanceFactorDefault;
            
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            CGPoint center = item.center;
            if (delta < 0) center.x += MAX(delta, delta*scrollResistance);
            else center.x += MIN(delta, delta*scrollResistance);
            
            item.center = center;
            
            [self.dynamicAnimator updateItemUsingCurrentState:item];
        }
    }];
    
    return NO;
}


-(CGSize)itemSize
{
    return CGSizeMake(320 * self.scaleFactor, 568 * self.scaleFactor);
}

- (void)resizeItemAtIndexPath:(NSIndexPath*)indexPath withPinchDistance:(CGFloat)distance
{
    self.pinchedItem = indexPath;
    self.pinchedItemSize = CGSizeMake(distance, distance * 568 / 320);
    
}

- (void)scaleItemAtIndexPath:(NSIndexPath*)indexPath withScaleFactor:(CGFloat)scale
{
    self.scaledItem = indexPath;
    self.scaleFactor = scale;
}

- (void)translateItemAtIndexPath:(NSIndexPath *)indexPath withTranslation:(CGPoint)translation
{
    self.draggedItem = indexPath;
    self.draggedTo = translation;
}

- (void)setScaleFactor:(CGFloat)scaleFactor
{
    _scaleFactor = MIN(scaleFactor, 1.0);
}

@end
