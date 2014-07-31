//
//  PKDetailViewController.m
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKDetailViewController.h"

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
    // Update the user interface for the detail item.
    i = 0;
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
    if (i >= self.shots.count) {
        i = 0;
    }
    NSDictionary *shotDictionary = self.shots[i];
    ALAssetRepresentation *representation = [shotDictionary objectForKey:@"representation"];
    
    self.shotView.image = [UIImage imageWithCGImage:representation.fullScreenImage scale:2.0 orientation:UIImageOrientationUp];
    i++;
    
    if (i < self.shots.count) {
        NSDictionary *shotDictionary = self.shots[i];
        ALAssetRepresentation *representation = [shotDictionary objectForKey:@"representation"];
        
        self.underShotView.image = [UIImage imageWithCGImage:representation.fullScreenImage scale:2.0 orientation:UIImageOrientationUp];
    } else {
        self.underShotView.image = nil;
    }
}

@end
