//
//  CoreDataManager.m
//  Jaunt
//
//  Created by John Bowles on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoreDataManager.h"
#import "Logger.h"

@implementation CoreDataManager

+(NSMutableArray*) executeFetch:(NSManagedObjectContext*) aContext forEntity:(NSString*) anEntity 
					withPredicate:(NSPredicate*) aPredicate usingFilter:(NSString*) aColumnName {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntity inManagedObjectContext:aContext];
	[request setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:aColumnName ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	NSError *error = nil;
	NSMutableArray *results = [[[aContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[Logger logError:error withMessage:@"Failed to execute fetch for entity"];
	
	[request release];
	
	return results;
}

@end
