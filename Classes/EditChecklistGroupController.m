//
//  EditChecklistGroupController.m
//  Jaunt
//
//  Created by John Bowles on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditChecklistGroupController.h"
#import "EditChecklistItemController.h"
#import "Trip.h"
#import "JauntAppDelegate.h"
#import "TextFieldCell.h"
#import	"CellManager.h"
#import	"CellExtension.h"
#import "ChecklistGroup.h"
#import "ChecklistItem.h"
#import "Logger.h"


@implementation EditChecklistGroupController

@synthesize trip;
@synthesize group;
@synthesize titles;
@synthesize groupName;
@synthesize cellManager;


#pragma mark -
#pragma mark View Management Methods

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem.target = self;
	self.navigationItem.rightBarButtonItem.action = @selector(toggleEditMode);
	
	[self loadTitles];
	[self loadCells];
}

- (void) toggleEditMode {
	
	if (self.tableView.editing == NO) {
		
		self.groupName = self.group.name;
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
		isEditing = YES;
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationRight];
    }
    else {
		isEditing = NO;
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void) viewWillAppear:(BOOL) animated {
	
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Cell Management Methods

-(void) loadTitles {
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"Add Item", nil];
	[self setTitles: array];
	[array release];
}

- (void) loadCells {
	
	NSArray *nibNames = [NSArray arrayWithObjects:@"TextFieldCell", nil];
	NSArray *identifiers = [NSArray arrayWithObjects:@"TextFieldCell", @"NonEditableCell", nil];
	
	CellManager *manager = [[CellManager alloc] initWithNibs:nibNames withIdentifiers:identifiers forOwner:self];
	self.cellManager = manager;
	
	[manager release];
}

#pragma mark -
#pragma mark Persistence Methods

- (void) save {
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	
	self.group.name = self.groupName;
	
	NSError *error;
	
	if (![aContext save: &error]) {
		
		[Logger logError:error withMessage:@"Failed to save checklistgroup"];
	}
	
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	
	if (section == 0) {
		
		return 1;
	} else {
		
		NSSet *checklistItems = [self.group checklistItems];
		
		if (self.editing)
			return checklistItems.count + 1;
		else
			return checklistItems.count;		
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
	
	return [self.titles count];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
	
	NSString *titleName = nil;
	
	if (section == 1) {
		
		titleName = @"Items";
	} 
	return titleName;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *) indexPath
{	
	if (indexPath.section == 1) {
		
		if (indexPath.row == 0 && isEditing == YES) {
			
			return UITableViewCellEditingStyleInsert;
		}
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		ChecklistItem *anItem = [[self.group.checklistItems allObjects] objectAtIndex:[self currentRowAtIndexPath:indexPath]];
		NSMutableSet *items = [self.group mutableSetValueForKey:@"checklistItems"];
		[items removeObject:anItem];
		
		JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
		
		[aContext deleteObject:anItem];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSString *reuseIdentifer = [self.cellManager reusableIdentifierForSection:indexPath.section];
	UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		if (indexPath.section == 0) {
				
			cell = [self.cellManager cellForSection:indexPath.section];
			[cell setCellExtensionDelegate:self];
			
		} else {
		
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer] autorelease];
		}
	}
	
	if (indexPath.section == 0) {
		
		[cell setTitleForCell: [self.titles objectAtIndex:indexPath.section]];
		[cell setValueForCell: self.group.name];
		
	} else {
		
		BOOL editingTrip = (indexPath.section == 1 && indexPath.row == 0 && self.editing);
		
		if (indexPath.row == 0 && editingTrip) {
			
			cell.textLabel.font = [UIFont systemFontOfSize:14.0];
			cell.textLabel.text = [self.titles objectAtIndex:indexPath.section];
			
		} else {
			
			NSSet *checklistItems = self.group.checklistItems;
			
			if ([checklistItems count] > 0) {
				
				ChecklistItem *anItem = [[checklistItems allObjects] objectAtIndex: [self currentRowAtIndexPath:indexPath]];
				cell.textLabel.font = [UIFont systemFontOfSize:14.0];
				cell.textLabel.text = anItem.name;
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton; 
				
				if ([anItem.checked intValue] == 1) {
					
					cell.imageView.image= [UIImage imageNamed:@"blue_checkmark.png"];
					
				} else {
					
					cell.imageView.image = nil;
				}
			}
		}
	}
	return cell;
}

- (NSUInteger) currentRowAtIndexPath: (NSIndexPath *) indexPath {
	
	NSUInteger row = indexPath.row;
	
	if (self.editing) {
		
		// Considers row added when there are no checklistgroup items
		row = row - 1;
	}
	
	row = row == -1 ? 0 : row;
	
	return row;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 1) {
		
		EditChecklistItemController *aController = [[EditChecklistItemController alloc] initWithStyle: UITableViewStyleGrouped];
		aController.title = @"Item";
		
		JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		
		if (self.editing == YES && indexPath.row == 0) {
			
			NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
			
			ChecklistItem *anItem = (ChecklistItem *) [NSEntityDescription insertNewObjectForEntityForName:@"ChecklistItem" inManagedObjectContext: aContext];
			anItem.name = @"";
			
			aController.checklistItem = anItem;
			
			NSMutableSet *checklistItems = [self.group mutableSetValueForKey:@"checklistItems"];
			[checklistItems addObject: anItem];
			
		} else {
			
			aController.checklistItem = [[self.group.checklistItems allObjects] objectAtIndex:[self currentRowAtIndexPath:indexPath]];
		}
		
		[delegate.navigationController pushViewController:aController animated:YES];
		[aController release];
	} 
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	if (indexPath.section == 1) {
		
		if (self.editing == YES && indexPath.row == 0) {
			
			JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
			EditChecklistItemController *aController = [[EditChecklistItemController alloc] initWithStyle: UITableViewStyleGrouped];
			aController.title = @"Item";
			NSManagedObjectContext *aContext = [aDelegate getManagedObjectContext];
			
			ChecklistItem *anItem = (ChecklistItem *) [NSEntityDescription insertNewObjectForEntityForName:@"ChecklistItem" inManagedObjectContext: aContext];
			anItem.name = @"";
			NSMutableSet *checklistItems = [self.group mutableSetValueForKey:@"checklistItems"];
			[checklistItems addObject: anItem];
			
			aController.checklistItem = anItem;
			[aDelegate.navigationController pushViewController:aController animated:YES];
			[aController release];
			
		} else {
			
			NSSet *checklistItems = self.group.checklistItems;
			
			if ([checklistItems count] > 0) {
				
				ChecklistItem *anItem = [[checklistItems allObjects] objectAtIndex: [self currentRowAtIndexPath:indexPath]];
				
				int checkedValue = [anItem.checked intValue];
				
				if (checkedValue == 1) {
					
					anItem.checked = [NSNumber numberWithInt:0];
				} else {
					
					anItem.checked = [NSNumber numberWithInt:1];
				}
				self.groupName = self.group.name;
				[self save];
				[tableView reloadData];
			}
		}
	} 
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void) textFieldDidEndEditing:(UITextField *) aTextField {
	
	self.groupName = aTextField.text;
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
	
	[trip release];
	[group release];
	[titles release];
	[groupName release];
	[cellManager release];
	[super dealloc];
}

@end