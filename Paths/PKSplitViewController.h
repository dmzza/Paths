//
//  PKSplitViewController.h
//  Paths
//
//  Created by David Mazza on 3/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKSplitViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) IBOutlet UIView *masterContainerView;

@end
