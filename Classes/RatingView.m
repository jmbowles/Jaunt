//
//  RatingView.m
//  Jaunt
//
//  Created by  on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

#define MAX_RATING 5.0

@implementation RatingView

@synthesize backgroundImageView, foregroundImageView;

- (void)_commonInit
{
    UIImageView *aBackGroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsBackground.png"]];
    aBackGroundImage.contentMode = UIViewContentModeLeft;
    self.backgroundImageView = aBackGroundImage;
    [self addSubview:aBackGroundImage];
    [aBackGroundImage release];
    
    UIImageView *aForeGroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsForeground.png"]];
    aForeGroundImage.contentMode = UIViewContentModeLeft;
    aForeGroundImage.clipsToBounds = YES;
    self.foregroundImageView = aForeGroundImage;
    [self addSubview:aForeGroundImage];
    [aForeGroundImage release];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self _commonInit];
    }
    
    return self;
}

- (void)setRating:(float)newRating
{
    rating = newRating;
    
    self.foregroundImageView.frame = CGRectMake(0.0, 0.0, backgroundImageView.frame.size.width * (rating / MAX_RATING), foregroundImageView.bounds.size.height);
}

- (float)rating
{
    return rating;
}

- (void)dealloc
{
    [backgroundImageView release];
    [foregroundImageView release];
        
    [super dealloc];
}
@end
