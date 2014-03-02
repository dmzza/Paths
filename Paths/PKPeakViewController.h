//
//  PKPeakViewController.h
//  Paths
//
//  Created by David Mazza on 2/21/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/Mapbox.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PKPeakViewControllerDelegate;

@interface PKPeakViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak) id <PKPeakViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *streetField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *nameField;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSString *assetUrl;

@end

@protocol PKPeakViewControllerDelegate <NSObject>

- (void) createNewPeakWithLocation:(CLLocationCoordinate2D)aLocation assetUrl:(NSString *)aUrl street:(NSString *)aStreet andName:(NSString *)aName;

@end