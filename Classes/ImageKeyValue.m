//
//  KeyValuePair.m
//  Jaunt
//
//  Created by John Bowles on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageKeyValue.h"


@implementation ImageKeyValue

@synthesize keyName;
@synthesize imageValue;


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[keyName release];
	[imageValue release];
	[super dealloc];
}

@end
