//
//  PKMasterViewController.m
//  Paths
//
//  Created by David Mazza on 1/20/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKMasterViewController.h"

#import "PKPageViewController.h"
#import "PKThumbnailCell.h"
#import "PKMapHeaderView.h"
#import "Path.h"
#import "Peak.h"

@interface PKMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PKMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
    [self.tableView registerClass:[PKMapHeaderView class] forHeaderFooterViewReuseIdentifier:@"mapHeader"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedPeaksController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedPeaksController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];

    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [[self.fetchedPeaksController sections] count];
    if (self.cameraRoll == nil) {
        return 0;
    }
    return [self.cameraRoll count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedPeaksController sections][section];
    //return [sectionInfo numberOfObjects] + 5;
    if (self.cameraRoll == nil) {
        return 0;
    }
    return [[self.cameraRoll objectAtIndex:self.cameraRoll.count - 1 - section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PKMapHeaderView *header = (PKMapHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"mapHeader"];
    
    NSMutableArray *photos = (NSMutableArray *)[self.cameraRoll objectAtIndex:self.cameraRoll.count - 1 - section];
    NSDictionary *firstPhoto = [photos objectAtIndex:0];
    CLLocationCoordinate2D center = [(CLLocation *)[firstPhoto objectForKey:@"location"] coordinate];
    CLLocationCoordinate2D lastCenter = center;
    double loLat, hiLat, loLon, hiLon, distance = 0.0;
    
    loLat = hiLat = center.latitude;
    loLon = hiLon = center.longitude;
    [header.map removeAnnotations:header.map.annotations];
    [header.date setText:(NSString *)[firstPhoto objectForKey:@"date"]];
    
    for (NSDictionary *photo in photos) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D center = [(CLLocation *)[photo objectForKey:@"location"] coordinate];
        
        loLat = MIN(loLat, center.latitude);
        hiLat = MAX(hiLat, center.latitude);
        loLon = MIN(loLon, center.longitude);
        hiLon = MAX(hiLon, center.longitude);
        distance += [[[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:lastCenter.latitude longitude:lastCenter.longitude]];
        [annotation setCoordinate:center];
        [header.map addAnnotation:annotation];
        lastCenter = center;
    }
    
    MKCoordinateSpan zoom = MKCoordinateSpanMake((hiLat - loLat) * 2, (hiLon - loLon) * 1.2);
    center = CLLocationCoordinate2DMake((hiLat + loLat) / 2, (hiLon + loLon) / 2);
    [header.map setRegion:MKCoordinateRegionMake(center, zoom)];
    [header.distance setText:[[NSString stringWithFormat:@"%.0f miles", distance * 0.000621371] uppercaseString]];
    [header.contentView setBackgroundColor:[[self.navigationController navigationBar] barTintColor]];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKThumbnailCell *cell = (PKThumbnailCell *)[tableView dequeueReusableCellWithIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedPeaksController managedObjectContext];
        [context deleteObject:[self.fetchedPeaksController objectAtIndexPath:indexPath]];

        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [[self fetchedPeaksController] objectAtIndexPath:indexPath];

        //TODO
        //self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedPeaksController] objectAtIndexPath:indexPath];

        //TODO
        //[[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedPeaksController {
    if (_fetchedPeaksController != nil) {
        return _fetchedPeaksController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Peak" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"longitude" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedPeaksController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"PathPeaks"];
    aFetchedPeaksController.delegate = self;
    self.fetchedPeaksController = aFetchedPeaksController;

	NSError *error = nil;
	if (![self.fetchedPeaksController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedPeaksController;
}

- (NSFetchedResultsController *)fetchedPathsController {
    if (_fetchedPeaksController != nil) {
        return _fetchedPeaksController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Path" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"longitude" ascending:NO];
    //NSArray *sortDescriptors = @[sortDescriptor];
    
    //[fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedPathsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Paths"];
    aFetchedPathsController.delegate = self;
    self.fetchedPathsController = aFetchedPathsController;
    
	NSError *error = nil;
	if (![self.fetchedPeaksController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedPeaksController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Grouped Assets

- (NSMutableArray *)cameraRoll
{
    if (_cameraRoll != nil) {
        return _cameraRoll;
    }
    
    __weak PKMasterViewController* weakSelf = self;
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //_cameraRoll = group;
            NSLog(@"found saved photos %@", [group description]);
            
            
            
            
            
            [group enumerateAssetsWithOptions:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    Path *dayPath;
                    //NSLog(@"photo: %@", represenation.metadata);
                    CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
                    if (location != nil) {
                        NSLog(@"photo");
                        
                        ALAssetRepresentation *representation = [result defaultRepresentation];
                        //UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:(UIImageOrientation)[representation orientation]];
                        NSDate *dateTaken = [result valueForProperty:ALAssetPropertyDate];
                        //NSDateFormatter *formatter = [NSDateFormatter dateFormatFromTemplate:@"yMMMMd" options:0 locale:[NSLocale currentLocale]];
                        NSString *formattedDate = [NSDateFormatter localizedStringFromDate:dateTaken dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
                        NSDictionary *photo = @{@"date": formattedDate, @"location": location, @"asset": result, @"representation": representation};
                        
                        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Path" inManagedObjectContext:self.managedObjectContext];
                        [fetchRequest setEntity:entity];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"WHERE `name` is ?" argumentArray:@[formattedDate]];
                        [fetchRequest setPredicate:predicate];
                        
                        NSFetchedResultsController *fetchedPathsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"Path%@", formattedDate]];
                        
                        NSError *error = nil;
                        if (![fetchedPathsController performFetch:&error]) {
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        }
                        
                        NSManagedObjectContext *context = [fetchedPathsController managedObjectContext];
                        if ([[fetchedPathsController fetchedObjects] count] < 1) {
                            NSManagedObject *newPath = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                            
                            // If appropriate, configure the new managed object.
                            // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
                            //[newPath setValue:formattedDate forKey:@"date"];
                            [newPath setValue:formattedDate forKey:@"name"];
                            
                            // Save the context.
                            NSError *error = nil;
                            if (![context save:&error]) {
                                // Replace this implementation with code to handle the error appropriately.
                                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                                abort();
                            }
                        }
                        
                        dayPath = (Path *)[[fetchedPathsController fetchedObjects] firstObject];
                        
                        if (days.count == 0 || ![[(NSDictionary *)[(NSMutableArray *)days.lastObject firstObject] objectForKey:@"date"] isEqualToString:formattedDate]) {
                            NSMutableArray *photos = [[NSMutableArray alloc] init];
                            [photos addObject:photo];
                            [days addObject:photos];
                            
                        } else {
                            [(NSMutableArray *)days.lastObject addObject:photo];
                        }
                        
                        Peak *newPeak = [[Peak alloc] init];
                        [newPeak setPhoto:representation.url.path];
                        [newPeak setLongitude:location.coordinate.longitude];
                        [newPeak setLatitude:location.coordinate.latitude];
                        [dayPath addPeaksObject:newPeak];
                        
                        // Save the context.
                        if (![context save:&error]) {
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        }
                    }
                    
                } else {
                    _cameraRoll = days;
                    NSLog(@"days: %d", days.count);
                    [weakSelf.tableView reloadData];
                }
            }];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"denied access to photos");
    }];
    
    return nil;
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

 - (void)controllerDidChangeContent:(NSfetchedPeaksController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(PKThumbnailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Path *path = [self.fetchedPathsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    Peak *peak = [path.peaks anyObject];
    //NSDictionary *photo = [(NSMutableArray *)[self.cameraRoll objectAtIndex:self.cameraRoll.count - 1 - indexPath.section] objectAtIndex:indexPath.row];
    ALAssetRepresentation *representation = [ALAssetRepresentation alloc] ini;
    
    //cell.headline.text = @"";
    [cell.photo setImage:[UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:UIImageOrientationUp]]; // (UIImageOrientation)[representation orientation]]];
    //[cell.photo setImage:(UIImage *)[photo objectForKey:@"image"]];
}

@end
