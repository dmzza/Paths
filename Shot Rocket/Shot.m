//
//  Shot.m
//  Shot Rocket
//
//  Created by David Mazza on 8/4/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "Shot.h"
#import "Shot.h"


@implementation Shot

@dynamic assetUrl;
@dynamic dateString;
@dynamic dateStamp;
@dynamic timeStamp;
@dynamic downVotes;
@dynamic latitude;
@dynamic longtiude;
@dynamic remoteUrl;
@dynamic updatedAt;
@dynamic upVotes;
@dynamic parent;
@dynamic groupedShots;

static NSURL *__persistentStoreURL = nil;

+ (NSString *)entityName {
	return @"Shot";
}

+ (NSArray *)defaultSortDescriptors
{
    NSSortDescriptor *sectionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateStamp" ascending:NO];
    NSSortDescriptor *voteSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"upVotes" ascending:NO];
    
    return @[sectionDescriptor, voteSortDescriptor];
}

+ (NSURL *)persistentStoreURL
{
    if (!__persistentStoreURL) {
        __persistentStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Shot_Rocket.sqlite"];
    }
    return __persistentStoreURL;
}

+ (Shot *)existingShotWithTimeStamp:(NSNumber *)timeStamp
{
    return [self existingShotWithTimeStamp:timeStamp context:nil];
}

+ (Shot *)existingShotWithTimeStamp:(NSNumber *)timeStamp context:(NSManagedObjectContext *)context
{
	// Default to the main context
	if (!context) {
		context = [self mainQueueContext];
	}
	
	// Create the fetch request for the ID
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [self entityWithContext:context];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"timeStamp = %@", timeStamp];
	fetchRequest.fetchLimit = 1;
	
	// Execute the fetch request
	NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
	
	// If the object is not found, return nil
	if (results.count == 0) {
		return nil;
	}
	
	// Return the object
	return [results objectAtIndex:0];
}

@end
