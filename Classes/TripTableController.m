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
#import "RouteController.h"
#import "ChecklistController.h"
#import	"ReservationController.h"
#import "WeatherController.h"
#import "CoreData/CoreData.h"
#import "Trip.h"
#import	"Photo.h"
#import	"Logger.h"
#import "CoreDataManager.h"
#import "ImageHelper.h"



@implementation TripTableController

@synthesize tripsCollection;
@synthesize navigationController;
@synthesize selectedTrip;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.rowHeight = 66.0;
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTrip)];
	addButton.enabled = YES;
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;

	[addButton release];
}

- (void) viewWillAppear:(BOOL) animated {
	
	[super viewWillAppear:animated];
	[self loadTrips];
	[self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL) animated {
	
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Persistence

- (NSManagedObjectContext *) getManagedObjectContext {
    
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [aDelegate getManagedObjectContext];
	
    return aContext;
}

- (void) loadTrips {

	NSMutableArray *results = [CoreDataManager executeFetch:[self getManagedObjectContext] forEntity:@"Trip" withPredicate:nil usingFilter:@"name"];
	[self setTripsCollection: results];
}

#pragma mark -
#pragma mark Methods

- (void) addTrip {
	
	AddTripController *addTripController = [[AddTripController alloc] initWithStyle: UITableViewStyleGrouped];
	addTripController.title = @"Add Trip";
		
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	[aDelegate.navigationController pushViewController:addTripController animated:YES];
	[addTripController release];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.tripsCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"TripNameCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	Trip *aTrip = [self.tripsCollection objectAtIndex: [indexPath row]];
	
	cell.textLabel.text = [aTrip name];	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	if (aTrip.photo.image == nil) {
		
		UIImage *anImage = [UIImage imageNamed:@"GenericContact.png"];
		cell.imageView.image = [ImageHelper image:anImage fillSize:CGSizeMake(88.0, 66.0)];
		
	} else {
		
		cell.imageView.image = aTrip.thumbNail;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		NSManagedObjectContext *aContext = [self getManagedObjectContext];
		
		NSManagedObject *trip = [self.tripsCollection objectAtIndex:indexPath.row];
		[aContext deleteObject:trip];
		
        [self.tripsCollection removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:YES];
				
		NSError *error;
		
		if (![aContext save:&error]) {
			
			[Logger logError:error withMessage:@"Failed to delete trip"];
		}
    }   
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	self.selectedTrip = [self.tripsCollection objectAtIndex:indexPath.row];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Map", @"Weather", @"Checklist", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 3;
	[actionSheet showInView: self.view];
	[actionSheet release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	Trip *aTrip = [self.tripsCollection objectAtIndex:indexPath.row];
	
	EditTripController	*editTripController = [[EditTripController alloc] initWithStyle: UITableViewStyleGrouped];
	editTripController.title = @"Edit Trip";
	editTripController.trip = aTrip;
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	[aDelegate.navigationController pushViewController:editTripController animated:YES];
	
	[editTripController release];
}

#pragma mark -
#pragma mark ActionSheet Navigation 

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	
	if (buttonIndex == 0)
	{
		RouteController *aController = [[RouteController alloc] initWithNibName:@"RouteView" bundle:[NSBundle mainBundle]];
		aController.title = @"Map";
		[aController setTrip:self.selectedTrip];
		[aDelegate.navigationController pushViewController:aController animated:YES];
		[aController release];
	}
	if (buttonIndex == 1)
	{
		WeatherController *aController = [[WeatherController alloc] initWithNibName:@"WeatherView" bundle:[NSBundle mainBundle]];
		aController.title = @"NOAA Weather";
		[aController setTrip:self.selectedTrip];
		[aDelegate.navigationController pushViewController:aController animated:YES];
		[aController release];
	}
	if (buttonIndex == 2)
	{
		ChecklistController *aController = [[ChecklistController alloc] initWithNibName:@"Checklist" bundle:[NSBundle mainBundle]];
		aController.title = @"Checklist";
		[aController setTrip:self.selectedTrip];
		[aDelegate.navigationController pushViewController:aController animated:YES];
		[aController release];
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {

	[tripsCollection release];
	[navigationController release];
	[selectedTrip release];
    [super dealloc];
}

@end
