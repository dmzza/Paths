//
//  PKDetailViewController.h
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import <SSDataKit/SSDataKit.h>

@interface PKDetailViewController : SSManagedCollectionViewController <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, nonatomic) NSString *dateStamp;
@property (nonatomic) NSInteger startingIndex;
@property (nonatomic) NSInteger nextIndex;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic, readonly) IBOutlet UICollectionView *collectionView;

@end
