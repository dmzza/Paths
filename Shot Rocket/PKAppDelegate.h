//
//  PKAppDelegate.h
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSDataKit/SSDataKit.h>

@class PKShotSync;
@class PKMasterViewController;

@interface PKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, atomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, atomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, atomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, atomic) PKShotSync *shotSync;
@property (strong, atomic) PKMasterViewController *masterVC;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
