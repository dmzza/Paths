//
//  Path.h
//  Paths
//
//  Created by David Mazza on 2/21/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Peak;

@interface Path : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *peaks;
@end

@interface Path (CoreDataGeneratedAccessors)

- (void)addPeaksObject:(Peak *)value;
- (void)removePeaksObject:(Peak *)value;
- (void)addPeaks:(NSSet *)values;
- (void)removePeaks:(NSSet *)values;

@end
