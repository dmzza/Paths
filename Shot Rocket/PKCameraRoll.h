//
//  PKCameraRoll.h
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@protocol PKCameraRollDelegate;

@interface PKCameraRoll : NSObject

@property (strong, nonatomic) NSMutableArray *shots;
@property (strong, nonatomic) ALAssetsLibrary *library;
@property (weak, nonatomic) id<PKCameraRollDelegate> delegate;

- (id)initWithDelegate:(id<PKCameraRollDelegate>)aDelegate;

@end

@protocol PKCameraRollDelegate <NSObject>

- (void)didLoadShot:(NSDictionary *)shotDictionary;

@end
