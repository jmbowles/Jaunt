//
//  EditChecklistItemController.m
//  Jaunt
//
//  Created by John Bowles on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditChecklistItemController.h"
#import	"JauntAppDelegate.h"
#import "TextFieldCell.h"
#import "CellManager.h"
#import "CellExtension.h"
#import "ChecklistGroup.h"
#import "ChecklistItem.h"
#import "TextFieldExtension.h"
#import "IndexedTextField.h"
#import	"Logger.h"
#import "ActivityManager.h"
#import "CoreDataManager.h"
#import "Checklist.h"


@implementation EditChecklistItemController

@synthesize titles;
@synthesize values;
@synthesize checklistItem;
@synthesize cellManager;
@synthesize searchDisplayController;
@synthesize items;
@synthesize fetchedResultsController;
@synthesize queue;

#pragma mark -
#pragma mark View Management


- (void) viewDidLoad {
	
	[super viewDidLoad];	
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	NSOperationQueue *aQueue = [[NSOperationQueue alloc] init];
	[aQueue setMaxConcurrentOperationCount:1];
	self.queue = aQueue;
	[aQueue release];
	
	[self loadTitles];
	[self loadCells];
	[self loadValues];
	[self configureSearchDisplay];
}

#pragma mark -
#pragma mark Post-Initialization Methods

- (void) loadTitles {
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Item:", nil];
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
		
		NSMutableArray *checklistValues = [[NSMutableArray alloc] initWithObjects: @"", nil];
		self.values = checklistValues;
		[checklistValues release];
		
	} 
	[self.values replaceObjectAtIndex:0 withObject: self.checklistItem.name];
}

-(void) configureSearchDisplay {
	
	NSMutableArray *anArray = [[NSMutableArray alloc] init];
	self.items = anArray;
	[anArray release];
	
	UISearchBar *aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
	aSearchBar.delegate = self;  
    aSearchBar.showsCancelButton = YES;  
	aSearchBar.placeholder = @"Search for checklist items";
	aSearchBar.keyboardType = UIKeyboardTypeASCIICapable;
	aSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	aSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [aSearchBar sizeToFit];  
    self.tableView.tableHeaderView = aSearchBar;  
	
	UISearchDisplayController *aSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:aSearchBar contentsController:self];  
	aSearchDisplayController.searchResultsDataSource = self;
	aSearchDisplayController.searchResultsDelegate = self;
	[aSearchDisplayController setDelegate:self];  
	[self setSearchDisplayController:aSearchDisplayController];
	
	[aSearchBar release];
	[aSearchDisplayController release];
}

#pragma mark -
#pragma mark Persistence

- (void) save {
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	
	self.checklistItem.name = [self.values objectAtIndex:0];
	
	NSError *error;
	
	if (![aContext save: &error]) {
		
		[Logger logError:error withMessage:@"Failed to save checklistitem"];
	}
	
	UINavigationController *aController = [delegate navigationController];
	[aController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.items count];
		
    } else {
		
		return self.titles.count;
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
	
	return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	if (self.tableView == tableView) {
		
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
		
	} else {
		
		static NSString *searchIdentifer = @"ChecklistItemSearchCell";
		UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: searchIdentifer];
		
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifer] autorelease];
		}
		
		ChecklistItem *anItem = [self.items objectAtIndex:indexPath.row];
		cell.textLabel.text = [anItem.name capitalizedString];
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
        ChecklistItem *anItem = [self.items objectAtIndex:indexPath.row];
		NSArray *anArray = [NSArray arrayWithObjects:[anItem.name capitalizedString], nil];		
		[self.values setArray:anArray];
		
		[self.searchDisplayController setActive:NO];
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void) textFieldDidBeginEditing:(UITextField *) aTextField {
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void) textFieldDidEndEditing:(UITextField *) aTextField {
	
	NSIndexPath *anIndexPath = [aTextField indexPathForField];
	[self.values replaceObjectAtIndex:anIndexPath.row withObject: aTextField.text];
	[self addValueToChecklist:aTextField.text];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *) aTextField {
	
	NSIndexPath *anIndexPath = [aTextField indexPathForField];
	
	// ChecklistItem name can be edited
	if (anIndexPath.row == 0) {
		return YES;
	}
	return NO;
}

-(void) addValueToChecklist:(NSString *) aChecklistValue {
		 
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	
	// User is manually entering item. Add to checklist so they won't have to do this again
	BOOL exists = [CoreDataManager doesContext:aContext withEntity:@"Checklist" containValue:aChecklistValue forColumn:@"name"];
	
	if (exists == NO) {
		
		Checklist *aChecklist = (Checklist *) [NSEntityDescription insertNewObjectForEntityForName:@"Checklist" inManagedObjectContext: aContext];
		[aChecklist setValue:aChecklistValue forKey:@"name"];
		
		NSError *error;
		
		if (![aContext save: &error]) {
			
			[Logger logError:error withMessage:@"Failed to manually add item to checklist"];
		}
	}
}
	 
#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	
	[searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	
	NSArray *operations = [self.queue operations];
	
	if ([operations count] == 0) {
		
		NSArray *arguments = [NSArray arrayWithObjects:searchString, [self fetchedResultsController], nil];
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(asyncSearch:) object:arguments];
		[self.queue addOperation:operation];
		[operation release];
	}
	
	return NO;
}

-(void) asyncSearch:(id) anArray {
	
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	
	NSArray *arguments = (NSArray *) anArray;
	NSString *aSearchString = (NSString *) [arguments objectAtIndex:0];
	
	NSFetchedResultsController *aController = (NSFetchedResultsController *) [arguments objectAtIndex:1];
	NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"%K beginswith[cd]%@",@"name", aSearchString];
	[aController.fetchRequest setPredicate:aPredicate];
	
	NSError *error;
	NSArray *results = nil;
	
	if([aController performFetch:&error]) {
		
		results = [aController fetchedObjects];
	}
	
	[self performSelectorOnMainThread:@selector(finishedSearching:) withObject:results waitUntilDone:YES];
	[aPool drain];
}

-(void) finishedSearching:(NSArray *) results {
	
	[self.items removeAllObjects];
	
	if (results != nil && [results count] > 0) {
		
		[self.items setArray: results];
	}
	[self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        
		return fetchedResultsController;
    }
    
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	self.fetchedResultsController = [CoreDataManager fetchedResultsController:aContext forEntity:@"Checklist" columnName:@"name" delegate:self];
	
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[titles release];
	[values release];
	[checklistItem release];
	[cellManager release];
	[searchDisplayController release];
	[items release];
	[fetchedResultsController release];
	[queue release];
	[super dealloc];
}

@end