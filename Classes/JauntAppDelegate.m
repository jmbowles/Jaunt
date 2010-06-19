//
//  JauntAppDelegate.m
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "JauntAppDelegate.h"
#import "Logger.h"
#import "TripTableController.h"

@implementation JauntAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;


#pragma mark -
#pragma mark Application Delegation

- (void) applicationDidFinishLaunching:(UIApplication *)application {    
	
	[window addSubview: navigationController.view];
    [window makeKeyAndVisible];
}

#pragma mark -
#pragma mark Core Data stack

-(NSManagedObjectModel *) getManagedObjectModel {
	
	if (self.managedObjectModel != nil) {
        
		return self.managedObjectModel;
    }
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
	
    return self.managedObjectModel;
}

-(NSManagedObjectContext *) getManagedObjectContext {
	
	if (self.managedObjectContext != nil) {
        
		return self.managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self getPersistentStoreCoordinator];
    
	if (coordinator != nil) {
        
		NSManagedObjectContext *aContext = [[NSManagedObjectContext alloc] init];
		self.managedObjectContext = aContext;
		[aContext release];
		
        [self.managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	return self.managedObjectContext;
}

-(NSPersistentStoreCoordinator *) getPersistentStoreCoordinator {
	
	if (self.persistentStoreCoordinator != nil) {
        
		return self.persistentStoreCoordinator;
    }
	
	NSPersistentStoreCoordinator *aCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self getManagedObjectModel]];
	self.persistentStoreCoordinator = aCoordinator;
	[aCoordinator release];
    
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Jaunt.sqlite"];
	
	// Make changes to the database schema by selecting model and choosing 'Add Model Version', select model with number, then 'Set Current Version'
	// Perform a clean / build
	// Backup/copy Jaunt.sqlite from Resources directory to iPhone folder.
	// Delete app from simulator 
	// Comment this block of code out. It allows the new database to be created and copied to storePath 
	// Run app
	// Open new database from simulator path using MesaSQLite 
	// Import ZCITY.csv and ZChecklist from iPhone Import folder
	// Add index to destination and city tables.  Use backup of database as a reference
	// Copy database to Resources folder, uncomment block of code
	// Run app

	// Start comment here

	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:storePath]) {
		
		NSString *databaseDeployedWithAppPath = [[NSBundle mainBundle] pathForResource:@"Jaunt" ofType:@"sqlite"];
		
		if (databaseDeployedWithAppPath) {
			[fileManager copyItemAtPath:databaseDeployedWithAppPath toPath:storePath error:NULL];
		}
	}

	// End comment here
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	NSError *error;
	
	if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        
		[Logger logError:error withMessage:@"Failed to add persistent store"];
    }    
	
    return self.persistentStoreCoordinator;
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
    return basePath;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
	[navigationController release];
    [window release];
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[super dealloc];
}

@end
