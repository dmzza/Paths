//
//  PKShotSync.m
//  Shot Rocket
//
//  Created by David Mazza on 8/4/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKShotSync.h"
#import "Shot.h"
#import "PKCameraRoll.h"

@implementation PKShotSync

- (id)init
{
    self = [super init];
    if (self) {
        self.cameraRoll = [[PKCameraRoll alloc] initWithDelegate:self];
    }
    return self;
}

- (void)shotsDidFinishLoading
{
    NSLog(@"shots finished");
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Shot"];
    for (NSArray *day in self.cameraRoll.shots) {
        for (NSDictionary *shotDictionary in day) {
            error = nil;
            [request setPredicate:[NSPredicate predicateWithFormat:@"timeStamp = %@", [shotDictionary objectForKey:@"timestamp"]]];
            if ([self.managedObjectContext countForFetchRequest:request error:&error] == 0 && error == nil) {
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shot" inManagedObjectContext:self.managedObjectContext];
                Shot *shot = [[Shot alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
            
                shot.assetUrl = [[(ALAssetRepresentation *)[shotDictionary objectForKey:@"representation"] url] absoluteString];
                shot.dateString = [shotDictionary objectForKey:@"dateString"];
                shot.dateStamp = [shotDictionary objectForKey:@"dateStamp"];
                shot.timeStamp = [shotDictionary objectForKey:@"timeStamp"];
                shot.latitude = [NSNumber numberWithDouble:[(CLLocation *)[shotDictionary objectForKey:@"location"] coordinate].latitude];
                shot.longtiude = [NSNumber numberWithDouble:[(CLLocation *)[shotDictionary objectForKey:@"location"] coordinate].longitude];
                //shot.remoteUrl = [shotDictionary objectForKey:@""];
                //shot.updatedAt = [shotDictionary objectForKey:@""];
                //shot.parent = [shotDictionary objectForKey:@""];
                NSLog(@"Shot created");
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Error syncing shots: %@", error.description);
                } else {
                    NSLog(@"Shots syncd");
                }
            } else {
                if (error != nil) {
                    NSLog(@"Error counting shots: %@", error.description);
                } else {
                    NSLog(@"Shot already exists");
                }
            }
        }
    }
    
    
}

@end
