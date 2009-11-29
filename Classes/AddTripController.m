//
//  AddTripController.m
//  Jaunt
//
//  Created by John Bowles on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddTripController.h"
#import "Trip.h"
#import "JauntAppDelegate.h"
#import	"CellManager.h"
#import "IndexedTextField.h"
#import	"TextFieldExtension.h"
#import "CellExtension.h"
#import	"Logger.h"

@implementation AddTripController


@synthesize tripName;
@synthesize cellManager;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[saveButton release];
	
	[self loadCells];
}

#pragma mark -
#pragma mark Cell Management Methods

- (void) loadCells {
	
	NSArray *nibNames = [NSArray arrayWithObjects:@"TextFieldCell", nil];
	NSArray *identifiers = [NSArray arrayWithObjects:@"TextFieldCell", nil];
	
	CellManager *manager = [[CellManager alloc] initWithNibs:nibNames withIdentifiers:identifiers forOwner:self];
	self.cellManager = manager;
	
	[manager release];
}

#pragma mark -
#pragma mark Persistence

- (void) save {
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [aDelegate managedObjectContext];
	
	Trip *trip = (Trip *) [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext: aContext];
	[trip setName: self.tripName];
	
	NSError *error;
	
	if (![aContext save: &error]) {
		
		[Logger logError:error withMessage:@"Failed to add trip"];
	}
	
	UINavigationController *aController = [aDelegate navigationController];
	[aController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
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
	[cell setTitleForCell: @"Name:"];
	
	return cell;
}

#pragma mark -
#pragma mark Text Field Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *) textField
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void) textFieldDidEndEditing:(UITextField *) aTextField {
	
	[self setTripName:aTextField.text];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[tripName release];
	[cellManager release];
	[super dealloc];
}

@end
