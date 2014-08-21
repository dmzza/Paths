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

- (void)didLoadShot:(NSDictionary *)shotDictionary
{
    
    if (![Shot existingShotWithTimeStamp:[shotDictionary objectForKey:@"timeStamp"] context:[Shot privateQueueContext]]) {
        Shot *shot = [[Shot alloc] initWithContext:[Shot privateQueueContext]];
        
        shot.assetUrl = [[(ALAssetRepresentation *)[shotDictionary objectForKey:@"representation"] url] absoluteString];
        shot.dateString = [shotDictionary objectForKey:@"dateString"];
        shot.dateStamp = [shotDictionary objectForKey:@"dateStamp"];
        shot.timeStamp = [shotDictionary objectForKey:@"timeStamp"];
        shot.latitude = [NSNumber numberWithDouble:[(CLLocation *)[shotDictionary objectForKey:@"location"] coordinate].latitude];
        shot.longtiude = [NSNumber numberWithDouble:[(CLLocation *)[shotDictionary objectForKey:@"location"] coordinate].longitude];
        //shot.remoteUrl = [shotDictionary objectForKey:@""];
        //shot.updatedAt = [shotDictionary objectForKey:@""];
        //shot.parent = [shotDictionary objectForKey:@""];
        
        if ([shot save]) {
            NSLog(@"Shot created");
        } else {
            NSLog(@"Couldn't save shot");
        }
    } else {
        NSLog(@"Shot already exists");
    }
}

@end
