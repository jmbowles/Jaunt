//
//  RatingTableViewCell.h
//  Jaunt
//
//  Created by  on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface RatingTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *icon;
    IBOutlet UILabel *nameLabel;
    IBOutlet RatingView *ratingView;
    IBOutlet UILabel *milesLabel;
    IBOutlet UILabel *addressLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *icon;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet RatingView *ratingView;
@property (nonatomic, retain) IBOutlet UILabel *milesLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;

-(void)setBackgroundColor:(UIColor *)backgroundColor;

@end
