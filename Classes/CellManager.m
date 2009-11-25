//
//  CellManager.m
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CellManager.h"


@implementation CellManager

@synthesize nibNames;
@synthesize reusableIdentifiers;
@synthesize owner;

#pragma mark -
#pragma mark Constructors

-(id) init {

	return [self initWithNibs:nil withIdentifiers:nil forOwner:nil];
}

- (id) initWithNibs:(NSArray*) names withIdentifiers:(NSArray *) identifiers forOwner:(id) anOwner {
	
	if (self = [super init]) {
		
		self.nibNames = names;
		self.reusableIdentifiers = identifiers;
		self.owner = anOwner;
	}
	return self;
}

#pragma mark -
#pragma mark Cell Manager Methods

-(UITableViewCell *) cellForSection:(NSUInteger) section {
	
	NSString *aNibName = [self.nibNames objectAtIndex: section];
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:aNibName owner:self.owner options:nil];
	UITableViewCell *cell = [nib objectAtIndex: 0];
	
	return cell;
}

-(NSString *) reusableIdentifierForSection:(NSUInteger) section {
	
	return [self.reusableIdentifiers objectAtIndex:section];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[nibNames release];
	[reusableIdentifiers release];
	[owner release];
	[super dealloc];
}

@end
