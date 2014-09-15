//
//  PKZoomInTransition.m
//  Shot Rocket
//
//  Created by David Mazza on 9/12/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKZoomInTransition.h"

@implementation PKZoomInTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
}

@end
