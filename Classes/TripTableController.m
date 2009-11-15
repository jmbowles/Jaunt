//
//  TripTableController.m
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TripTableController.h"
#import "JauntAppDelegate.h"
#import	"AddTripController.h"
#import	"EditTripController.h"
#import "CoreData/CoreData.h"
#import "Trip.h"

@implementation TripTableController

@synthesize tripsCollection;
@synthesize navigationController;

#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	[self loadTrips];
		
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTrip)];
	addButton.enabled = YES;
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;
	
	[addButton release];
}

- (void)viewDidUnload {
	
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.tripsCollection = nil;
	self.navigationController = nil;
}

#pragma mark -
#pragma mark Persistence

- (NSManagedObjectContext *) getManagedObjectContext {
    
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
	
    return managedObjectContext;
}

- (void) loadTrips {

	NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];

	// Gets all trips that have been savedß∫
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Sort by the trip's name
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Get the list of all trips
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	[self setTripsCollection: mutableFetchResults];
	
	[entity	release];
	[mutableFetchResults release];
	[request release];
}

#pragma mark -
#pragma mark Methods

/**
 Add a new trip
 */
- (void) addTrip {

	AddTripController *addTripController = [[AddTripController alloc] initWithStyle: UITableViewStyleGrouped];
	addTripController.title = @"Add Trip";
	addTripController.tripsCollection = self.tripsCollection; 
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[addTripController setManagedObjectContext: [delegate managedObjectContext]];
	
	[delegate.navigationController pushViewController:addTripController animated:YES];
	[addTripController release];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.tripsCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *TripNameCellIdentifier = @"TripNameCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: TripNameCellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:TripNameCellIdentifier] autorelease];
	}
	
	Trip *aTrip = [self.tripsCollection objectAtIndex: [indexPath row]];
	
	cell.text = [aTrip name];	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

/**
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];
		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [self.tripsCollection objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:eventToDelete];
		
		// Update the array and table view.
        [self.tripsCollection removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:YES];
		
		// Commit the change.
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
		}
    }   
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	Trip *aTrip = [self.tripsCollection objectAtIndex:indexPath.row];
	
	EditTripController	*editTripController = [[EditTripController alloc] initWithStyle: UITableViewStyleGrouped];
	editTripController.title = @"Edit Trip";
	editTripController.trip = aTrip;
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationController pushViewController:editTripController animated:YES];
	
	[editTripController release];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {

	[tripsCollection release];
	[navigationController release];
    [super dealloc];
}

@end
