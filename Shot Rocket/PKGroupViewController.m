//
//  PKGroupViewController.m
//  Shot Rocket
//
//  Created by David Mazza on 8/2/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKGroupViewController.h"
#import "PKShotCell.h"
#import "PKDetailViewController.h"
#import "Shot.h"

@interface PKGroupViewController ()

@end

@implementation PKGroupViewController

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
    self.library = [[ALAssetsLibrary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        NSString *date = [[self.shots firstObject] objectForKey:@"date"];
        [[segue destinationViewController] setStartingIndex:indexPath.item];
        [[segue destinationViewController] setShots:self.shots];
        [[segue destinationViewController] setTitle:date];
    }
}

#pragma mark - Collection View delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shots.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PKShotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShotCell" forIndexPath:indexPath];
    Shot *shot = [self.shots objectAtIndex:indexPath.item];
    
    [self.library assetForURL:[NSURL URLWithString:shot.assetUrl] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        cell.baseShotView.image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:2.0 orientation:UIImageOrientationUp];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed getting asset: %@", error.description);
    }];
    return cell;
}

@end
