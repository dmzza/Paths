//
//  Shot.h
//  Shot Rocket
//
//  Created by David Mazza on 8/4/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Shot;

@interface Shot : NSManagedObject

@property (nonatomic, retain) NSString * assetUrl;
@property (nonatomic, retain) NSString * dateString;
@property (nonatomic, retain) NSNumber * dateTaken;
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

@end
