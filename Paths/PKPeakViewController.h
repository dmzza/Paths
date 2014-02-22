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
@property (weak, nonatomic) IBOutlet RMMapView *mapView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *streetField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSString *assetUrl;

@end

@protocol PKPeakViewControllerDelegate <NSObject>

- (void) createNewPeakWithLocation:(CLLocationCoordinate2D)aLocation assetUrl:(NSString *)aUrl street:(NSString *)aStreet andName:(NSString *)aName;

@end