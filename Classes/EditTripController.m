//
//  EditTripController.m
//  Jaunt
//
//  Created by John Bowles on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditTripController.h"
#import "Trip.h"
#import "JauntAppDelegate.h"
#import "TextFieldCell.h"
#import	"CellManager.h"
#import	"CellExtension.h"
#import "DestinationController.h"
#import "Destination.h"


@implementation EditTripController

@synthesize titles;
@synthesize tripsCollection;
@synthesize trip;
@synthesize tripName;
@synthesize cellManager;


#pragma mark -
#pragma mark View Management Methods

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"Add Destination", nil];
	[self setTitles: array];
	[array release];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem.target = self;
	self.navigationItem.rightBarButtonItem.action = @selector(toggleEditMode);
	
	[self loadCells];
}

- (void) toggleEditMode {
	
	if (self.tableView.editing == NO) {
		
		self.tripName = self.trip.name;
		self.tableView.allowsSelectionDuringEditing = YES;
		[self setEditing:YES animated:YES];
		
	} else {

		[self save];
		[self setEditing:NO animated:YES];
	}
}

- (void) setEditing:(BOOL) editing animated:(BOOL) animated
{
    [super setEditing:editing animated:animated];
	
	NSArray *paths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:1]];
    
	if (self.editing)
    {
		isEditingTrip = YES;
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];
    }
    else {
		isEditingTrip = NO;
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }
}
	
- (void) viewWillAppear:(BOOL) animated {
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Cell Management Methods

- (void) loadCells {

	NSArray *nibNames = [NSArray arrayWithObjects:@"TextFieldCell", @"NonEditableCell", nil];
	NSArray *identifiers = [NSArray arrayWithObjects:@"TextFieldCell", @"NonEditableCell", nil];
	
	CellManager *manager = [[CellManager alloc] initWithNibs:nibNames withIdentifiers:identifiers forOwner:self];
	self.cellManager = manager;
	
	[manager release];
}

#pragma mark -
#pragma mark Persistence Methods

- (void) save {
	
	[self.trip setName: self.tripName];
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate managedObjectContext];
	
	NSError *error;
	
	if (![aContext save: &error]) {
		
		NSLog(@"Failed to save destination: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	
	if (section == 0) {
		
		return 1;
	} else {
		
		NSSet *destinations = [[self trip] destinations];
				
		if (self.editing)
			return destinations.count + 1;
		else
			return destinations.count;		
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {

	return [self.titles count];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
	
	NSString *titleName = @"Trip";
	
	if (section == 1) {
		
		titleName = @"Destinations";
	} 
	return titleName;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *) indexPath
{	
	if (indexPath.section == 1) {
		
		if (indexPath.row == 0 && isEditingTrip == YES) {
		
			return UITableViewCellEditingStyleInsert;
		}
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		Destination *aDestination = [[self.trip.destinations allObjects] objectAtIndex:[self currentRowAtIndexPath:indexPath]];
		NSMutableSet *destinations = [self.trip mutableSetValueForKey:@"destinations"];
		[destinations removeObject:aDestination];
		
		JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *aContext = [delegate managedObjectContext];
	
		[aContext deleteObject:aDestination];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSString *reuseIdentifer = [self.cellManager reusableIdentifierForSection:indexPath.section];
	UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [self.cellManager cellForSection:indexPath.section];
	}
	
	[cell setCellExtensionDelegate:self];
	[cell setValueForCell: self.trip.name];
	
	BOOL editingTrip = (indexPath.section == 1 && indexPath.row == 0 && self.editing);
	
	if (indexPath.section == 0 || editingTrip) {
		
		[cell setTitleForCell: [self.titles objectAtIndex:indexPath.section]];
	} else {
		
		NSSet *destinations = self.trip.destinations;
		Destination *destination = [[destinations allObjects] objectAtIndex: [self currentRowAtIndexPath:indexPath]];
		[cell setTitleForCell: destination.name];
	}
	return cell;
}

- (NSUInteger) currentRowAtIndexPath: (NSIndexPath *) indexPath {
	
	NSUInteger row = indexPath.row;
	
	if (self.editing) {
		
		// Considers row added when there are no destinations
		row = row - 1;
	}
	
	row = row == -1 ? 0 : row;
	
	return row;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	if (indexPath.section == 1) {
		
		DestinationController *controller = [[DestinationController alloc] initWithStyle: UITableViewStyleGrouped];
		controller.trip = self.trip;
		controller.title = @"Destination";
		
		if ([trip.destinations count] > 0) {
			
			controller.destination = [[trip.destinations allObjects] objectAtIndex:[self currentRowAtIndexPath:indexPath]];
		} else {
			controller.destination = nil;
		}
		
		JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void) textFieldDidEndEditing:(UITextField *) aTextField {
	
	self.tripName = aTextField.text;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) aTextField {

	if (self.tableView.editing) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	return self.tableView.editing;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[titles release];
	[tripsCollection release];
	[trip release];
	[tripName release];
	[cellManager release];
	[super dealloc];
}

@end
