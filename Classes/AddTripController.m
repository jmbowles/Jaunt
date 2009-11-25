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

@implementation AddTripController

@synthesize tripNameTextField;
@synthesize tripsCollection;
@synthesize managedObjectContext;

#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	saveButton.enabled = YES;
	
    self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
}

- (void)viewDidUnload {
	
	self.tripsCollection = nil;
	self.tripNameTextField = nil;
	self.managedObjectContext = nil;
}


#pragma mark -
#pragma mark Persistence

- (void) save {
	
	Trip *trip = (Trip *) [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext: self.managedObjectContext];
	[trip setName: tripNameTextField.text];	
	
	[self.tripsCollection insertObject:trip atIndex:0];

	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	UINavigationController *aController = [delegate navigationController];
	[aController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return kNumberOfRows;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	static NSString *AddTripCellIdentifier = @"AddTripCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: AddTripCellIdentifier];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:AddTripCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 125, 25)];
		label.text = @"Name:";
		label.textAlignment = UITextAlignmentLeft;
		label.tag = kLabelTag;
		label.font = [UIFont boldSystemFontOfSize: 14];
		[cell.contentView addSubview: label];
		[label release];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 12, 200, 25)];
		textField.clearsOnBeginEditing = YES;
		[textField setDelegate: self];
		[cell.contentView addSubview: textField];
		[textField release];
	}
	
	return cell;
}

#pragma mark -
#pragma mark Text Field Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *) textField
{
	[self setTripNameTextField: textField];
}


#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[tripsCollection release];
	[tripNameTextField release];
	[managedObjectContext release];
	[super dealloc];
}

@end
