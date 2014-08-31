//
//  PKMasterViewController.m
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKMasterViewController.h"
#import "PKDetailViewController.h"
#import "PKGroupCell.h"
#import "Shot.h"
#import "PKShotSync.h"
#import "PKCameraRoll.h"

@interface PKMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PKMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.library = [[ALAssetsLibrary alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:note waitUntilDone:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = [super numberOfSectionsInTableView:tableView];
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fetchedResultsController == nil) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKGroupCell *cell = (PKGroupCell *)[tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showGroup"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSLog(@"%u", [(id<NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[0] objects].count);
        NSArray *shots = [(id<NSFetchedResultsSectionInfo>)[self.fetchedResultsController sections][indexPath.section] objects];
        NSString *date = [[shots firstObject] dateString];
        
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        [[segue destinationViewController] setShots:shots];
        [[segue destinationViewController] setTitle:date];
    }
}


- (void)configureCell:(PKGroupCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Shot *shot = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.library assetForURL:[NSURL URLWithString:shot.assetUrl] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        cell.bestImageView.image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:UIImageOrientationUp];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed getting asset: %@", error.description);
    }];
    
    cell.nameLabel.text = [shot dateString];
    
}

#pragma mark - Configuration

+ (Class)fetchedResultsControllerClass {
	return [NSFetchedResultsController class];
}


- (NSFetchRequest *)fetchRequest {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [self.entityClass entityWithContext:self.managedObjectContext];
	fetchRequest.sortDescriptors = self.sortDescriptors;
	fetchRequest.predicate = self.predicate;
	return fetchRequest;
}


- (Class)entityClass {
	return [Shot class];
}


- (NSArray *)sortDescriptors {
	return [[self entityClass] defaultSortDescriptors];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithValue:YES];
}


- (NSManagedObjectContext *)managedObjectContext {
    return [[self entityClass] mainQueueContext];
}


- (NSString *)sectionNameKeyPath {
	return @"dateStamp";
}


- (NSString *)cacheName {
	return @"Master";
}

@end
