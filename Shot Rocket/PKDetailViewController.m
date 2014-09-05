//
//  PKDetailViewController.m
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKDetailViewController.h"
#import "PKShotCell.h"
#import "PKZoomingFlowLayout.h"
#import "Shot.h"

@interface PKDetailViewController ()
- (void)configureView;
@end

@implementation PKDetailViewController {
    NSInteger i;
    
}

#pragma mark - Managing the detail item

- (void)configureView
{
    self.library = [[ALAssetsLibrary alloc] init];
    
    // Update the user interface for the detail item.
    if (self.startingIndex) {
        self.nextIndex = self.startingIndex;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC/10)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.startingIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        });
    } else {
        self.nextIndex = 0;
    }
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator.delegate = self;
    
    //[self loadNextShot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (IBAction)likeShot {
    /*Shot *shot = [self.collectionView indexPathForItemAtPoint:<#(CGPoint)#>];
    NSError *error;
    
    shot.upVotes = [NSNumber numberWithInt:[shot.upVotes intValue] + 1];
    
    if (![shot save]) {
        NSLog(@"Error saving like");
    }
    //[self loadNextShot];*/
}

- (IBAction)skipShot {
    //[self loadNextShot];
}
- (IBAction)didDragShot:(UIPanGestureRecognizer *)sender {
    //[self.animator removeAllBehaviors];
    
    CGPoint translation = [sender translationInView:self.collectionView];
    NSIndexPath *draggedItem = [self.collectionView indexPathForItemAtPoint:translation];
    PKShotCell *selectedCell = (PKShotCell *)[self.collectionView cellForItemAtIndexPath:draggedItem];
    UIGestureRecognizerState state = [sender state];
    __weak __typeof__(self) weakSelf = self;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint anchor = translation;
            anchor.x += 160;
            anchor.y += 284;
            /*UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:selectedCell attachedToAnchor: anchor];
            attachmentBehavior.length = 0.0;
            [self.animator removeAllBehaviors];
            [self.animator addBehavior:attachmentBehavior];*/
            
            PKZoomingFlowLayout* layout = (PKZoomingFlowLayout*)[[self collectionView] collectionViewLayout];
            
            [layout translateItemAtIndexPath:draggedItem withTranslation:translation];
            [layout invalidateLayout];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            //[self.shotView setTransform:CGAffineTransformMakeTranslation(translation.x*2, translation.y*2)];
            
            
            if (translation.x > 0) { // right
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[selectedCell] mode:UIPushBehaviorModeInstantaneous];
                pushBehavior.pushDirection = CGVectorMake(200.0, 0);
                [self.animator removeAllBehaviors];
                [self.animator addBehavior:pushBehavior];
                //[self likeShot];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.animator removeAllBehaviors];
                    UISnapBehavior *attachmentBehavior = [[UISnapBehavior alloc] initWithItem:selectedCell snapToPoint:self.view.center];
                    [weakSelf.animator addBehavior:attachmentBehavior];
                });
                /*[UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.shotView setTransform:CGAffineTransformMakeTranslation(640, translation.y)];
                } completion:^(BOOL finished) {
                    [weakSelf likeShot];
                    [weakSelf.shotView setTransform:CGAffineTransformIdentity];
                }];*/
             
            }/* else if (translation.x < 0) { // left
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.shotView setTransform:CGAffineTransformMakeTranslation(-640 - translation.x, 0)];
                } completion:^(BOOL finished) {
                    [weakSelf skipShot];
                    [weakSelf.shotView setTransform:CGAffineTransformIdentity];
                }];
            } else {
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:10 options:0 animations:^{
                    [self.shotView setTransform:CGAffineTransformIdentity];
                } completion:^(BOOL finished) {
                    
                }];
            }*/
            
            break;
        }
        
        default:
            break;
    }
    
    
}

- (IBAction)didPinchShot:(UIPinchGestureRecognizer *)sender {
    if ([sender numberOfTouches] != 2) {
        PKZoomingFlowLayout* layout = (PKZoomingFlowLayout*)[[self collectionView] collectionViewLayout];
        
        [layout setScaleFactor:1.0];
        [layout invalidateLayout];
        return;
    }
    
    
    
    if (sender.state == UIGestureRecognizerStateBegan ||
        sender.state == UIGestureRecognizerStateChanged) {
        // Get the pinch points.
        CGPoint p1 = [sender locationOfTouch:0 inView:[self collectionView]];
        CGPoint p2 = [sender locationOfTouch:1 inView:[self collectionView]];
        
        // Compute the new spread distance.
        CGFloat xd = p1.x - p2.x;
        CGFloat yd = p1.y - p2.y;
        CGFloat distance = sqrt(xd*xd + yd*yd);
        
        // Update the custom layout parameter and invalidate.
        PKZoomingFlowLayout* layout = (PKZoomingFlowLayout*)[[self collectionView] collectionViewLayout];
        
        NSIndexPath *pinchedItem = [self.collectionView indexPathForItemAtPoint:CGPointMake(0.5*(p1.x+p2.x), 0.5*(p1.y+p2.y))];
        //[layout resizeItemAtIndexPath:pinchedItem withPinchDistance:distance];
        [layout scaleItemAtIndexPath:pinchedItem withScaleFactor:[sender scale]];
        [layout invalidateLayout];
        
    }
    else if (sender.state == UIGestureRecognizerStateCancelled ||
             sender.state == UIGestureRecognizerStateEnded){
        PKZoomingFlowLayout* layout = (PKZoomingFlowLayout*)[[self collectionView] collectionViewLayout];
        
        [layout setScaleFactor:1.0];
        [layout invalidateLayout];
    }
}

/*- (void)loadNextShot
{
    i = self.nextIndex;
    Shot *shot = [self.shots objectAtIndex:i];
    
    [self.library assetForURL:[NSURL URLWithString:shot.assetUrl] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        self.shotView.image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:UIImageOrientationUp];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed getting asset: %@", error.description);
    }];
    
    self.nextIndex = i+1;
    if (self.nextIndex >= self.shots.count) {
        self.nextIndex = 0;
    }
    
    shot = [self.shots objectAtIndex:self.nextIndex];
        
    [self.library assetForURL:[NSURL URLWithString:shot.assetUrl] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
            
        self.underShotView.image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:UIImageOrientationUp];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed getting asset: %@", error.description);
    }];
}*/

#pragma mark - Collection View Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PKShotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShotCell" forIndexPath:indexPath];
    Shot *shot = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.library assetForURL:[NSURL URLWithString:shot.assetUrl] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        cell.baseShotView.image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:UIImageOrientationUp];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed getting asset: %@", error.description);
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"sections: %ld", [super numberOfSectionsInCollectionView:collectionView]);
    return [super numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"section # %ld : %ld", section, [super collectionView:collectionView numberOfItemsInSection:section]);
    
    return [super collectionView:collectionView numberOfItemsInSection:section];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

#pragma mark - UIDynamicAnimator delegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    //[self.animator removeAllBehaviors];
    //[self.shotView setTransform:CGAffineTransformIdentity];
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
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
	return [NSPredicate predicateWithFormat:@"dateStamp = %@", self.dateStamp];
}


- (NSManagedObjectContext *)managedObjectContext {
    return [[self entityClass] mainQueueContext];
}

/*- (NSString *)cacheName {
	return self.title;
}*/

- (BOOL)useLayoutToLayoutNavigationTransitions
{
    return NO;
}

@end
