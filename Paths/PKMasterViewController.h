//
//  PKMasterViewController.h
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PKPageViewController;

#import <CoreData/CoreData.h>

@interface PKMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) PKPageViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedPeaksController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedPathsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, nonatomic) NSMutableArray *cameraRoll;

@end
