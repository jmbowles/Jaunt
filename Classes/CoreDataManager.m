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
	[request setPredicate:aPredicate];
	[sortDescriptor release];
	[sortDescriptors release];
	
	NSError *error = nil;
	NSMutableArray *results = [[[aContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[request release];
	
	return results;
}

+(NSFetchedResultsController *)fetchedResultsController:(NSManagedObjectContext*) aContext forEntity:(NSString*) anEntity 
								columnName:(NSString *) aColumnName delegate:(id) aDelegate {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntity inManagedObjectContext:aContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *aDescriptor = [[NSSortDescriptor alloc] initWithKey:aColumnName ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:aDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																managedObjectContext:aContext sectionNameKeyPath:nil cacheName:nil];
	aFetchedResultsController.delegate = aDelegate;
	
	[fetchRequest release];
	[aDescriptor release];
	[sortDescriptors release];
	
	return [aFetchedResultsController autorelease];
}

+(BOOL) doesContext:(NSManagedObjectContext*) aContext withEntity:(NSString *) anEntity containValue:(NSString *) 
			aRowValue forColumn:(NSString *) aColumnName {
	
	BOOL containsValue = NO;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntity inManagedObjectContext:aContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *aDescriptor = [[NSSortDescriptor alloc] initWithKey:aColumnName ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:aDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
												managedObjectContext:aContext sectionNameKeyPath:nil cacheName:nil];
	
	NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"%K beginswith[cd]%@", aColumnName, aRowValue];
	[aController.fetchRequest setPredicate:aPredicate];
	
	NSError *error;
		
	if([aController performFetch:&error]) {
		
		NSArray *results = [aController fetchedObjects];
		
		if ([results count] > 0) {
				
			containsValue = YES;
			
		} else {
				
			containsValue = NO;
		}
		
	} else {
		
		// Error occurred, so, default
		containsValue = YES;
	}

	[fetchRequest release];
	[aDescriptor release];
	[sortDescriptors release];
	[aController release];
	
	return containsValue;
}
@end
