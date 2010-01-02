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
#import "City.h"
#import "TextFieldExtension.h"
#import "IndexedTextField.h"
#import	"Logger.h"
#import "CoreDataManager.h"

@implementation DestinationController


@synthesize titles;
@synthesize values;
@synthesize trip;
@synthesize destination;
@synthesize cellManager;
@synthesize searchDisplayController;
@synthesize cities;
@synthesize fetchedResultsController;

#pragma mark -
#pragma mark View Management


- (void) viewDidLoad {
	
	[super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	[self loadTitles];
	[self loadCells];
	[self loadValues];
	[self configureSearchDisplay];
}

#pragma mark -
#pragma mark Post-Initialization Methods

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

-(void) configureSearchDisplay {

	NSMutableArray *anArray = [[NSMutableArray alloc] init];
	self.cities = anArray;
	[anArray release];
	
	UISearchBar *aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
	aSearchBar.delegate = self;  
    aSearchBar.showsCancelButton = YES;  
	aSearchBar.prompt = @"Search for city and state";
	aSearchBar.keyboardType = UIKeyboardTypeASCIICapable;
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
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.cities count];
		
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
		
		static NSString *searchIdentifer = @"SearchCell";
		UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier: searchIdentifer];
		
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifer] autorelease];
		}
		
		City *aCity = [self.cities objectAtIndex:indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", aCity.cityName, aCity.stateCode];;
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
        City *aCity = [self.cities objectAtIndex:indexPath.row];
		NSArray *anArray = [NSArray arrayWithObjects:aCity.cityName, aCity.cityName, aCity.stateCode, nil];		
		[self.values setArray:anArray];
		
		[self.searchDisplayController setActive:NO];
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
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	[self.cities removeAllObjects];
	
	NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"%K like [cd]%@",@"cityName", searchBar.text];
	NSFetchedResultsController *aController = [self fetchedResultsController];
	[aController.fetchRequest setPredicate:aPredicate];
	
	NSError *error;
	
	if(! [aController performFetch:&error]) {
		
		[Logger logError:error withMessage:@"Failed to filter city"];
		
	} else {
		
		NSArray *results = [aController fetchedObjects];
		[self.cities setArray: results];
		[self.searchDisplayController.searchResultsTableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	
	[searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	
	return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        
		return fetchedResultsController;
    }
    
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	self.fetchedResultsController = [CoreDataManager fetchedResultsController:aContext forEntity:@"City" columnName:@"cityName" delegate:self];
	
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[titles release];
	[values release];
	[trip release];
	[destination release];
	[cellManager release];
	[searchDisplayController release];
	[cities release];
	[fetchedResultsController release];
	[super dealloc];
}

@end
