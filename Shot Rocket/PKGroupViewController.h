//
//  PKGroupViewController.h
//  Shot Rocket
//
//  Created by David Mazza on 8/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>

@interface PKGroupViewController : UICollectionViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *shots;
@property (strong, nonatomic) ALAssetsLibrary *library;

@end
