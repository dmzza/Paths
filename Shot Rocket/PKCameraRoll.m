//
//  PKCameraRoll.m
//  Shot Rocket
//
//  Created by David Mazza on 7/24/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKCameraRoll.h"

@implementation PKCameraRoll

- (id)initWithDelegate:(id<PKCameraRollDelegate>)aDelegate {
    self = [super init];
    if (self) {
        self.library = [[ALAssetsLibrary alloc] init];
        _delegate = aDelegate;
        [self shots];
    }
    return self;
}

- (NSMutableArray *)shots
{
    if (_shots != nil) {
        return _shots;
    }
    
    __weak PKCameraRoll* weakSelf = self;
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    // Photo Stream
    //[self.library enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    // Camera Roll
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //_cameraRoll = group;
            NSLog(@"found saved photos %@", [group description]);
            
            
            
            if (group.numberOfAssets == 0) {
                return;
            }
            
            [group enumerateAssetsWithOptions:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    //NSLog(@"photo: %@", represenation.metadata);
                    CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
                    // TODO: Remove this fake location, just used to test with the iPod
                    if (location == nil) {
                        location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
                    }
                    if (location != nil) {
                        NSLog(@"photo");
                        
                        ALAssetRepresentation *representation = [result defaultRepresentation];
                        if (representation == nil) {
                            return;
                        }
                        //UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:(UIImageOrientation)[representation orientation]];
                        NSDate *dateTaken = [result valueForProperty:ALAssetPropertyDate];
                        //NSDateFormatter *formatter = [NSDateFormatter dateFormatFromTemplate:@"yMMMMd" options:0 locale:[NSLocale currentLocale]];
                        NSTimeInterval timeStamp = [dateTaken timeIntervalSince1970];
                        NSString *dateString = [NSDateFormatter localizedStringFromDate:dateTaken dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
                        NSDateFormatter *dateStampFormatter = [[NSDateFormatter alloc] init];
                        [dateStampFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *dateStamp = [dateStampFormatter stringFromDate:dateTaken];
                        NSDictionary *photo = @{@"timeStamp": [NSNumber numberWithDouble:timeStamp], @"dateString": dateString, @"dateStamp": dateStamp, @"location": location, @"asset": result, @"representation": representation};
                        
                        if (days.count == 0 || ![[(NSDictionary *)[(NSMutableArray *)days.lastObject firstObject] objectForKey:@"date"] isEqualToString:dateStamp]) {
                            NSMutableArray *photos = [[NSMutableArray alloc] init];
                            [photos addObject:photo];
                            [days addObject:photos];
                            
                        } else {
                            [(NSMutableArray *)days.lastObject addObject:photo];
                        }
                        
                    }
                    return;
                } else if(index > 0) {
                    _shots = [NSMutableArray arrayWithArray:[[days reverseObjectEnumerator] allObjects]];
                    NSLog(@"days: %lu", (unsigned long)days.count);
                    [weakSelf.delegate shotsDidFinishLoading];
                }
            }];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"denied access to photos");
    }];
    
    return nil;
}

/*- (void)setDelegate:(id<PKCameraRollDelegate>)delegate
{
    NSLog(@"delegate: %@", delegate.description);
    _delegate = delegate;
}*/

@end
