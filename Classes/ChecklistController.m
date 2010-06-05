//
//  ChecklistController.m
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoreData/CoreData.h"
#import "ChecklistController.h"
#import "CoreDataManager.h"
#import "JauntAppDelegate.h"
#import "Logger.h"

@implementation ChecklistController

@synthesize items;


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
	[self loadItems];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Persistence

- (NSManagedObjectContext *) getManagedObjectContext {
    
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [aDelegate getManagedObjectContext];
	
    return aContext;
}

- (void) loadItems {
	
	//NSMutableArray *results = [CoreDataManager executeFetch:[self getManagedObjectContext] forEntity:@"ChecklistItem" withPredicate:nil usingFilter:@"name"];
	//[self setItems: results];
	
	NSArray *dummy = [NSArray arrayWithObjects:@"Fee",@"Fie",@"Foe",@"Fum",nil];
	NSMutableArray *dummyValues = [NSMutableArray array];
	[dummyValues addObjectsFromArray:dummy];
	[self setItems:dummyValues];
}

#pragma mark -
#pragma mark Methods

- (void) addItem {
	
	/**
	AddTripController *addTripController = [[AddTripController alloc] initWithStyle: UITableViewStyleGrouped];
	addTripController.title = @"Add Trip";
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	[aDelegate.navigationController pushViewController:addTripController animated:YES];
	[addTripController release];
	 **/
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"ItemNameCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.textLabel.text = [self.items objectAtIndex: [indexPath row]];
	
	/**
	Trip *aTrip = [self.tripsCollection objectAtIndex: [indexPath row]];
	
	cell.textLabel.text = [aTrip name];	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	if (aTrip.photo.image == nil) {
		
		UIImage *anImage = [UIImage imageNamed:@"GenericContact.png"];
		cell.imageView.image = [ImageHelper image:anImage fillSize:CGSizeMake(88.0, 66.0)];
		
	} else {
		
		cell.imageView.image = aTrip.thumbNail;
	}
	 **/
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		NSManagedObjectContext *aContext = [self getManagedObjectContext];
		
		NSManagedObject *trip = [self.items objectAtIndex:indexPath.row];
		[aContext deleteObject:trip];
		
        [self.items removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:YES];
		
		NSError *error;
		
		if (![aContext save:&error]) {
			
			[Logger logError:error withMessage:@"Failed to delete checklist item"];
		}
    }   
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	/**
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Delete Item", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 1;
	[actionSheet showInView: self.view];
	[actionSheet release];
	 **/
		
		
	UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath]; 
	
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else {
		
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
}


#pragma mark -
#pragma mark ActionSheet Navigation 

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
	//JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	
	if (buttonIndex == 0)
	{
		
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[items release];
    [super dealloc];
}

@end
