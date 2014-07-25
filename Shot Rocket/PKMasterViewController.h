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

@class PKCameraRoll;
@protocol PKCameraRollDelegate;

@interface PKMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, PKCameraRollDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, nonatomic) PKCameraRoll *cameraRoll;

- (void)shotsDidFinishLoading;

@end
