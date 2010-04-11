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
#import "Destination.h"

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

-(Destination *) findDestinationWithLatitude:(NSString *) aLatitude andLongitude:(NSString *) aLongitude {
	
	Destination *target = nil;
	
	NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
	[aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[aNumberFormatter setMaximumFractionDigits:2];
	[aNumberFormatter setMaximumIntegerDigits:3];
	
	NSNumber *targetLatNumber = [[NSNumber alloc] initWithDouble:[aLatitude doubleValue]];
	NSNumber *targetLongNumber = [[NSNumber alloc] initWithDouble:[aLongitude doubleValue]];
	NSString *targetLat = [aNumberFormatter stringFromNumber:targetLatNumber];
	NSString *targetLong = [aNumberFormatter stringFromNumber:targetLongNumber];
	[targetLatNumber release];
	[targetLongNumber release];
	
	for (Destination *aDestination in [self.destinations allObjects]) {
		
		NSNumber *sourceLatNumber = [[NSNumber alloc] initWithDouble:[aDestination.latitude doubleValue]];
		NSNumber *sourceLongNumber = [[NSNumber alloc] initWithDouble:[aDestination.longitude doubleValue]];
		NSString *sourceLat = [aNumberFormatter stringFromNumber:sourceLatNumber];
		NSString *sourceLong = [aNumberFormatter stringFromNumber:sourceLongNumber];
		[sourceLatNumber release];
		[sourceLongNumber release];
		
		if ([sourceLat isEqualToString:targetLat] == YES &&
			[sourceLong isEqualToString:targetLong] == YES) {
			
			target = aDestination;
			break;
		}
	}
	
	[aNumberFormatter release];
	
	return target;
}

@end
