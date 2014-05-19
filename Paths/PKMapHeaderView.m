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
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 116)];
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 280, 20)];
        [self.map setUserInteractionEnabled:NO];
        [self.date setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f]];
        [self.date setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.map];
        [self.contentView addSubview:self.date];
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
