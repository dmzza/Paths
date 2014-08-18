//
//  PKMasterViewController.h
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreData/CoreData.h>

@class PKShotSync;
@protocol PKCameraRollDelegate;

@interface PKMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, atomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, atomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ALAssetsLibrary *library;

@end
