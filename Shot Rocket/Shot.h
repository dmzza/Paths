//
//  Shot.h
//  Shot Rocket
//
//  Created by David Mazza on 8/4/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <SSDataKit/SSDataKit.h>

@class Shot;

@interface Shot : SSManagedObject

@property (nonatomic, retain) NSString * assetUrl;
@property (nonatomic, retain) NSString * dateString;
@property (nonatomic, retain) NSString * dateStamp;
@property (nonatomic, retain) NSNumber * timeStamp;
@property (nonatomic, retain) NSNumber * downVotes;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtiude;
@property (nonatomic, retain) NSString * remoteUrl;
@property (nonatomic, retain) NSNumber * updatedAt;
@property (nonatomic, retain) NSNumber * upVotes;
@property (nonatomic, retain) Shot *parent;
@property (nonatomic, retain) NSSet *groupedShots;
@end

@interface Shot (CoreDataGeneratedAccessors)

- (void)addGroupedShotsObject:(Shot *)value;
- (void)removeGroupedShotsObject:(Shot *)value;
- (void)addGroupedShots:(NSSet *)values;
- (void)removeGroupedShots:(NSSet *)values;

+ (Shot *)existingShotWithTimeStamp:(NSNumber *)timeStamp;
+ (Shot *)existingShotWithTimeStamp:(NSNumber *)timeStamp context:(NSManagedObjectContext *)context;

@end
