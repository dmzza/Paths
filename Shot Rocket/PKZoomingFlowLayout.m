//
//  PKZoomingFlowLayout.m
//  Shot Rocket
//
//  Created by David Mazza on 9/1/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKZoomingFlowLayout.h"

@implementation PKZoomingFlowLayout


- (void)awakeFromNib
{
    self.pinchedItem = 0;
    self.pinchedItemSize = CGSizeMake(320, 568);
}

- (UICollectionViewScrollDirection)scrollDirection
{
    return UICollectionViewScrollDirectionVertical;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    //    NSLog(@"attributes for rect %@\n%@", NSStringFromCGRect(rect), attrs);
    
    if (_pinchedItem) {
        UICollectionViewLayoutAttributes *attr = [[attrs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"indexPath == %@", _pinchedItem]] firstObject];
        
        attr.size = _pinchedItemSize;
        attr.zIndex = 100;
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if ([indexPath isEqual:_pinchedItem]) {
        attr.size = _pinchedItemSize;
        attr.zIndex = 100;
    }
    
    return attr;
}


-(CGSize)itemSize
{
    return CGSizeMake(self.pinchedItemSize.width, self.pinchedItemSize.height);
}

- (void)resizeItemAtIndexPath:(NSIndexPath*)indexPath withPinchDistance:(CGFloat)distance
{
    self.pinchedItem = indexPath;
    self.pinchedItemSize = CGSizeMake(distance, distance * 568 / 320);
    
}

- (void)translateItemAtIndexPath:(NSIndexPath *)indexPath withTranslation:(CGPoint)translation
{
    self.draggedItem = indexPath;
    self.draggedTo = translation;
}

@end
