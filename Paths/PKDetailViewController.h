//
//  PKDetailViewController.h
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PKPhotoTableViewCell.h"
#import "PKMapTableViewCell.h"
#import "PKPathMarkerCell.h"
#import "PKPeakViewController.h"
#import "Peak.h"

@interface PKDetailViewController : UIViewController <NSFetchedResultsControllerDelegate, PKPeakViewControllerDelegate, RMMapViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedPeaksController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (strong, nonatomic) RMMapboxSource *tileSource;
@property (strong, nonatomic) IBOutlet UIView *photoCard;
@property (strong, nonatomic) IBOutlet UILabel *streetLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *centerAttachment;

@end
