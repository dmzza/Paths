//
//  PKShotSync.h
//  Shot Rocket
//
//  Created by David Mazza on 8/4/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PKCameraRoll;
@protocol PKCameraRollDelegate;

@interface PKShotSync : NSObject <PKCameraRollDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) PKCameraRoll *cameraRoll;

- (void)didLoadShot:(NSDictionary *)shotDictionary;

@end
