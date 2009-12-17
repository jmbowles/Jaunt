//
//  ViewManager.m
//  Jaunt
//
//  Created by John Bowles on 12/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewManager.h"


@implementation ViewManager

+(UIView *) viewWithPhotoButtonForTarget:(id) aTarget andAction:(SEL) anAction usingTag:(NSInteger) 
			aTag width:(CGFloat) aWidth height:(CGFloat) aHeight {

	CGRect aFrame = CGRectMake(20, 18, 62, 62);
	
	UIImage *anImage = [UIImage imageNamed:@"GenericContact.png"];
	UIButton *aButton = [[UIButton alloc] initWithFrame:aFrame];
	[aButton setBackgroundImage:anImage forState:UIControlStateNormal];
	aButton.titleLabel.font = [UIFont systemFontOfSize: 12];
	[aButton setTitle:@"add photo" forState:UIControlStateNormal];
	[aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[aButton addTarget:aTarget action:anAction forControlEvents:UIControlEventTouchUpInside];
	aButton.tag = aTag;
	
	aFrame = CGRectMake(0, 0, aWidth, aHeight);
	UIView *aHeaderView = [[[UIView alloc] initWithFrame:aFrame] autorelease];
	[aHeaderView addSubview:aButton];
	aHeaderView.backgroundColor = [UIColor clearColor];
	
	[aButton release];
	
	return	aHeaderView;
}

@end
