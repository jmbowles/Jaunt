//
//  Trip.m
//  Jaunt
//
//  Created by John Bowles on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Trip.h"
#import "Photo.h"
#import "UIImageToDataTransformer.h"

@implementation Trip

@dynamic name;
@dynamic destinations;
@dynamic thumbNail;
@dynamic photo;

+(void) initialize {
	
	if (self == [Trip class]) {
		
		UIImageToDataTransformer *transformer = [[[UIImageToDataTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
