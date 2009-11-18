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

@implementation EditTripController

@synthesize list;
@synthesize tripsCollection;
@synthesize trip;
@synthesize managedObjectContext;
@synthesize tripName;
@synthesize cellManager;

#pragma mark -
#pragma mark View Management Methods

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"Add Destination", nil];
	[self setList: array];
	[array release];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem.target = self;
	self.navigationItem.rightBarButtonItem.action = @selector(toggleEditMode);
	
	[self loadCells];
}

- (void) toggleEditMode {
	
	if (self.tableView.editing == NO) {
		
		self.tripName = self.trip.name;
		[self setEditing:YES animated:YES];
		
	} else {

		[self save];
		[self setEditing:NO animated:YES];
	}
}

- (void) viewDidUnload {
	
	
}

- (void) setEditing:(BOOL) editing animated:(BOOL) animated
{
    [super setEditing:editing animated:animated];
	
	NSArray *paths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:1]];
    
	if (editing)
    {
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];
    }
    else {
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }
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
	
	NSError *error;
	[managedObjectContext save: &error];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	
	if (section == 0) {
		
		return 1;
	} else {
		
		NSSet *destinations = [[self trip] destinations];
				
		if ([tableView isEditing])
			return destinations.count + 1;
		else
			return destinations.count;		
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {

	return [self.list count];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
	
	NSString *titleName = @"Trip";
	
	if (section == 1) {
		
		titleName = @"Destinations";
	} 
	return titleName;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		
		return UITableViewCellEditingStyleInsert;
	}
	return UITableViewCellEditingStyleNone;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		
    }  
	[self save];
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
	[cell setTitleForCell: [self.list objectAtIndex:indexPath.section]];
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	
	[list release];
	[tripsCollection release];
	[trip release];
	[managedObjectContext release];
	[tripName release];
	[cellManager release];
	[super dealloc];
}

@end
