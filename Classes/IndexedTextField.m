//
//  IndexedTextField.m
//  Jaunt
//
//  Created by John Bowles on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IndexedTextField.h"


@implementation IndexedTextField

@synthesize fieldIndexPath;


#pragma mark -
#pragma mark TextField Category Extension

- (void) setIndexPathForField:(NSIndexPath*) anIndexPath {
	
	[self setFieldIndexPath:anIndexPath];
}

- (NSIndexPath*) indexPathForField {
	
	return [self fieldIndexPath];
}


#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[fieldIndexPath release];
	[super dealloc];
}

@end
