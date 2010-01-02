//
//  CoreDataManager.h
//  Jaunt
//
//  Created by John Bowles on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataManager : NSObject {

}

+(NSMutableArray*) executeFetch:(NSManagedObjectContext*) aContext forEntity:(NSString*) anEntity 
				  withPredicate:(NSPredicate*) aPredicate usingFilter:(NSString*) aColumnName;

+(NSFetchedResultsController *)fetchedResultsController:(NSManagedObjectContext*) aContext forEntity:(NSString*) 
								anEntity columnName:(NSString *) aColumnName delegate:(id) aDelegate;

@end
