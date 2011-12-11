//
//  RatingTableViewCell.m
//  Jaunt
//
//  Created by  on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RatingTableViewCell.h"

@implementation RatingTableViewCell

@synthesize icon, nameLabel, ratingView, milesLabel, addressLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    icon.backgroundColor = backgroundColor;
    nameLabel.backgroundColor = backgroundColor;
    ratingView.backgroundColor = backgroundColor;
    milesLabel.backgroundColor = backgroundColor;
    addressLabel.backgroundColor = backgroundColor;
}

- (void)dealloc
{
    [icon release];
    [nameLabel release];
    [ratingView release];
    [milesLabel release];
    [addressLabel release];
    
    [super dealloc];
}

@end
