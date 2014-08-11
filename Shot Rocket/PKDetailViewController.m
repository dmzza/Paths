//
//  PKDetailViewController.m
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKDetailViewController.h"
#import "Shot.h"

@interface PKDetailViewController ()
- (void)configureView;
@end

@implementation PKDetailViewController {
    NSInteger i;
    
}

#pragma mark - Managing the detail item

- (void)setShots:(NSArray *)shots
{
    if (_shots != shots) {
        _shots = shots;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    self.library = [[ALAssetsLibrary alloc] init];
    
    // Update the user interface for the detail item.
    if (self.startingIndex) {
        self.nextIndex = self.startingIndex;
    } else {
        self.nextIndex = 0;
    }
    
    [self loadNextShot];
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
    Shot *shot = [self.shots objectAtIndex:i];
    NSError *error;
    
    shot.upVotes = [NSNumber numberWithInt:[shot.upVotes intValue] + 1];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving like: %@", error.description);
    }
    [self loadNextShot];
}

- (IBAction)skipShot {
    [self loadNextShot];
}
- (IBAction)didDragShot:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    UIGestureRecognizerState state = [sender state];
    __weak __typeof__(self) weakSelf = self;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.shotView setTransform:CGAffineTransformMakeTranslation(translation.x*2, translation.y*2)];
            break;
        
        case UIGestureRecognizerStateEnded:
            [self.shotView setTransform:CGAffineTransformMakeTranslation(translation.x*2, translation.y*2)];
            if (translation.x > 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.shotView setTransform:CGAffineTransformMakeTranslation(640, translation.y)];
                } completion:^(BOOL finished) {
                    [weakSelf likeShot];
                    [weakSelf.shotView setTransform:CGAffineTransformIdentity];
                }];
                
                /*[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [weakSelf.shotView setTransform:CGAffineTransformMakeTranslation(640, translation.y)];
                } completion:^(BOOL finished) {
                    [weakSelf.shotView setTransform:CGAffineTransformMakeTranslation(-640, 0)];
                    [weakSelf likeShot];
                    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [weakSelf.shotView setTransform:CGAffineTransformIdentity];
                    } completion:^(BOOL finished) {
                        
                    }];
                }];*/
            } else if (translation.x < 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.shotView setTransform:CGAffineTransformMakeTranslation(-640 - translation.x, 0)];
                } completion:^(BOOL finished) {
                    [weakSelf likeShot];
                    [weakSelf.shotView setTransform:CGAffineTransformIdentity];
                }];
            } else {
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:10 options:0 animations:^{
                    [self.shotView setTransform:CGAffineTransformIdentity];
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            break;
        
        default:
            break;
    }
    
    
}

- (void)loadNextShot
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
}

@end
