//
//  JauntAppDelegate.m
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "JauntAppDelegate.h"
#import "Logger.h"


@implementation JauntAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize navigationController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;


#pragma mark -
#pragma mark Application Delegation

- (void) applicationDidFinishLaunching:(UIApplication *)application {    

	[window addSubview: rootController.view];
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
    
	NSError *error;
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Jaunt.sqlite"]];
	
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
    
	[rootController release];
	[navigationController release];
    [window release];
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[super dealloc];
}

@end
