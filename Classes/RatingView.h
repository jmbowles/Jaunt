//
//  RatingView.h
//  Jaunt
//
//  Created by  on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView
{
    float rating;
    UIImageView *backgroundImageView;
    UIImageView *foregroundImageView;
}

@property float rating;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImageView *foregroundImageView;

-(void)setRating:(float)newRating;

@end
