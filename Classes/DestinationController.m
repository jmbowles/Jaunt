//
//  DestinationController.m
//  Jaunt
//
//  Created by John Bowles on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import	"JauntAppDelegate.h"
#import "DestinationController.h"
#import "TextFieldCell.h"
#import "CellManager.h"
#import "CellExtension.h"
#import "Trip.h"
#import "Destination.h"
#import "TextFieldExtension.h"
#import "IndexedTextField.h"
#import	"Logger.h"

@implementation DestinationController


@synthesize titles;
@synthesize values;
@synthesize trip;
@synthesize destination;
@synthesize cellManager;


#pragma mark -
#pragma mark View Management Methods


- (void) viewDidLoad {
	
	[super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	[self loadTitles];
	[self loadCells];
	[self loadValues];
}

#pragma mark -
#pragma mark Cell Management Methods

- (void) loadTitles {
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"City:", @"State:", nil];
	[self setTitles: array];
	
	[array release];
}

- (void) loadCells {
	
	NSArray *nibNames = [NSArray arrayWithObjects:@"TextFieldCell", nil];
	NSArray *identifiers = [NSArray arrayWithObjects:@"TextFieldCell", nil];
	
	CellManager *manager = [[CellManager alloc] initWithNibs:nibNames withIdentifiers:identifiers forOwner:self];
	self.cellManager = manager;
	
	[manager release];
}

- (void) loadValues {

	if (self.values == nil) {
		
		NSMutableArray *destinationValues = [[NSMutableArray alloc] initWithObjects: @"", @"", @"", nil];
		self.values = destinationValues;
		
		[destinationValues release];
	}
	
	[self.values replaceObjectAtIndex:0 withObject: self.destination.name];
	[self.values replaceObjectAtIndex:1 withObject: self.destination.city];
	[self.values replaceObjectAtIndex:2 withObject: self.destination.state];
}

#pragma mark -
#pragma mark Persistence Methods

- (void) save {
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate managedObjectContext];
	
	self.destination.name = [self.values objectAtIndex:0];
	self.destination.city = [self.values objectAtIndex:1];
	self.destination.state = [self.values objectAtIndex:2];
	
	NSError *error;
	
	if (![aContext save: &error]) {
		
		[Logger logError:error withMessage:@"Failed to save destination"];
	}
	
	UINavigationController *aController = [delegate navigationController];
	[aController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	
	return self.titles.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
	
	return 1;
}


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	static NSString *reuseIdentifer = @"TextFieldCell";
	UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [self.cellManager cellForSection:indexPath.section];
		UITextField *aField = [cell indexedTextField];
		[aField setIndexPathForField: indexPath];
	}
	
	[cell setCellExtensionDelegate:self];
	[cell setValueForCell: [self.values objectAtIndex:indexPath.row]];
	[cell setTitleForCell: [self.titles objectAtIndex:indexPath.row]];
	
	return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void) textFieldDidBeginEditing:(UITextField *) aTextField {
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void) textFieldDidEndEditing:(UITextField *) aTextField {
	
	NSIndexPath *anIndexPath = [aTextField indexPathForField];
	[self.values replaceObjectAtIndex:anIndexPath.row withObject: aTextField.text];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[titles release];
	[values release];
	[trip release];
	[destination release];
	[cellManager release];
	[super dealloc];
}

@end
