//
//  ChecklistController.m
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoreData/CoreData.h"
#import "ChecklistController.h"
#import "AddChecklistGroupController.h"
#import "EditChecklistGroupController.h"
#import "Trip.h"
#import "ChecklistGroup.h"
#import "CoreDataManager.h"
#import "JauntAppDelegate.h"
#import "Logger.h"

@implementation ChecklistController

@synthesize trip;
@synthesize sortedGroups;
@synthesize selectedGroup;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
	addButton.enabled = YES;
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

- (void) viewWillAppear:(BOOL) animated {
	
	[super viewWillAppear:animated];
	
	NSSortDescriptor *aDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *aSortDescriptor = [NSArray arrayWithObject:aDescriptor];
	[aDescriptor release];
	NSArray *groups = [[self.trip.checklistGroups allObjects] sortedArrayUsingDescriptors:aSortDescriptor];
	self.sortedGroups = groups;
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Persistence

- (NSManagedObjectContext *) getManagedObjectContext {
    
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [aDelegate getManagedObjectContext];
	
    return aContext;
}

#pragma mark -
#pragma mark Methods

- (void) addItem {
	
	AddChecklistGroupController *aController = [[AddChecklistGroupController alloc] initWithStyle: UITableViewStyleGrouped];
	aController.trip = self.trip;
	aController.title = @"Add Checklist";
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.sortedGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"ChecklistGroupNameCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	ChecklistGroup *aGroup = [self.sortedGroups objectAtIndex:[indexPath row]];
	cell.textLabel.text = [aGroup name];
	
	if ([aGroup allItemsChecked] == YES) {
		
		cell.imageView.image = [UIImage imageNamed:@"blue_checkmark.png"];
		
	} else {
		cell.imageView.image = nil;
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	self.selectedGroup = [self.sortedGroups objectAtIndex:indexPath.row];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Checklist"
													otherButtonTitles:@"Clear Checklist", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 2;
	[actionSheet showInView: self.view];
	[actionSheet release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	EditChecklistGroupController *aController = [[EditChecklistGroupController alloc] initWithStyle: UITableViewStyleGrouped];
	aController.title = @"Edit Checklist";
	aController.trip = self.trip;
	aController.group = [self.sortedGroups objectAtIndex:indexPath.row];
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	
	[aController release];
}

#pragma mark -
#pragma mark ActionSheet Navigation 

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [aDelegate getManagedObjectContext];
	
	if (buttonIndex == 0)
	{
		[aContext deleteObject: self.selectedGroup];
		NSMutableSet *aSet = [self.trip mutableSetValueForKey:@"checklistGroups"];
		[aSet removeObject:self.selectedGroup];
		
		NSError *error;
		
		if (![aContext save: &error]) {
			
			[Logger logError:error withMessage:@"Failed to delete checklist group"];
		}
		[self.tableView reloadData];
	}
	
	if (buttonIndex == 1)
	{
		NSEnumerator *anEnumerator = [[self.selectedGroup checklistItems] objectEnumerator];
		
		NSManagedObject *item;
		
		while ((item = [anEnumerator nextObject])) {
			
			[aContext deleteObject: item];
		}
		
		NSMutableSet *aSet = [self.selectedGroup mutableSetValueForKey:@"checklistItems"];
		[aSet removeAllObjects];
		
		NSError *error;
		
		if (![aContext save: &error]) {
			
			[Logger logError:error withMessage:@"Failed to remove all checklist items"];
		}
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[trip release];
	[sortedGroups release];
	[selectedGroup release];
    [super dealloc];
}

@end
