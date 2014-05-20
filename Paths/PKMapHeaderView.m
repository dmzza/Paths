//
//  PKMapHeaderView.m
//  Paths
//
//  Created by David Mazza on 5/19/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKMapHeaderView.h"

@implementation PKMapHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 3, 320, 117)];
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 300, 20)];
        self.distance = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 300, 20)];
        [self.map setUserInteractionEnabled:NO];
        self.date.font = self.distance.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        self.date.alpha = self.distance.alpha = 0.4;
        [self.date setTextAlignment:NSTextAlignmentRight];
        [self.distance setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.map];
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.distance];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
