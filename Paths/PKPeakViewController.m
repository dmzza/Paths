//
//  PKPeakViewController.m
//  Paths
//
//  Created by David Mazza on 2/21/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKPeakViewController.h"

@interface PKPeakViewController ()

@end

@implementation PKPeakViewController {
    BOOL mapIsConfigured;
}

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mapIsConfigured = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!mapIsConfigured) {
        [self.mapView addTileSource:[[RMMapboxSource alloc] initWithMapID:@"dmzza.hbn76bcd"]];
        [self.mapView setTileSourcesZoom:16.0];
        [self.mapView setUserTrackingMode:RMUserTrackingModeFollow];
        mapIsConfigured = YES;
    }
}

- (IBAction)choosePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:^{
        
    }];
}

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)save:(id)sender {
    [self.delegate createNewPeakWithLocation:self.mapView.centerCoordinate assetUrl:self.assetUrl street:self.streetField.text andName:self.nameField.text];
}

# pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        self.assetUrl = [(NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        self.thumbnailView.image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
