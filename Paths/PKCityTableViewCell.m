//
//  PKCityTableViewCell.m
//  Paths
//
//  Created by David Mazza on 3/16/14.
//  Copyright (c) 2014 Peaking Software LLC. All rights reserved.
//

#import "PKCityTableViewCell.h"

@implementation PKCityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
