//
//  EditTripController.m
//  Jaunt
//
//  Created by John Bowles on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditTripController.h"
#import "Trip.h"
#import "Photo.h"
#import "JauntAppDelegate.h"
#import "TextFieldCell.h"
#import	"CellManager.h"
#import	"CellExtension.h"
#import "DestinationController.h"
#import "Destination.h"
#import "Logger.h"
#import "ActivityManager.h"
#import "CameraController.h"
#import "ViewManager.h"
#import "ImageHelper.h"


@implementation EditTripController


@synthesize cameraController;
@synthesize activityManager;
@synthesize titles;
@synthesize trip;
@synthesize tripName;
@synthesize cellManager;


#pragma mark -
#pragma mark View Management Methods

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem.target = self;
	self.navigationItem.rightBarButtonItem.action = @selector(toggleEditMode);
	
	[self initializeDelegates];
	[self createHeader];
	[self loadTitles];
	[self loadCells];
}

-(void) createHeader {
	
	UIView *aHeaderView = [ViewManager viewWithPhotoButtonForTarget:self andAction:@selector(setTripImage:) usingTag:1 
								width:self.tableView.bounds.size.width height:100];
	
	if (self.trip.photo.image != nil) {
		
		UIButton *aButton = (UIButton*)[aHeaderView viewWithTag:1];
		UIImage *anImage = [ImageHelper image:self.trip.thumbNail fillView:aButton];
		[aButton setBackgroundImage:anImage forState:UIControlStateNormal];
		
		[aButton setTitle:nil forState:UIControlStateNormal];
	}
	
	self.tableView.tableHeaderView = aHeaderView;
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
	
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Post Construction Initialization

-(void) initializeDelegates {
	
	CameraController *aCameraController = [[CameraController alloc] initWithController:self andActionView:self.tableView];
	self.cameraController = aCameraController;
	self.cameraController.delegate = self;
	[aCameraController release];
	
	ActivityManager *anActivityManager = [[ActivityManager alloc] initWithView:self.tableView];
	self.activityManager = anActivityManager;
	[anActivityManager release];
}

#pragma mark -
#pragma mark CameraControllerDelegate

-(void) didFinishSelectingImage {
	
	UIView *aHeaderView = self.tableView.tableHeaderView;
	UIButton *aButton = (UIButton*)[aHeaderView viewWithTag:1];
	
	UIImage *anImage = [ImageHelper image:self.cameraController.imageSelected fillView:aButton];
							  
	[aButton setBackgroundImage:anImage forState:UIControlStateNormal];
	[aButton setTitle:nil forState:UIControlStateNormal];
}

- (void) setTripImage:(id) sender {
	
	if (self.tableView.editing) {
		
		[self.cameraController selectImage];
	}
}

#pragma mark -
#pragma mark Cell Management Methods

-(void) loadTitles {
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"Add Destination", nil];
	[self setTitles: array];
	
	[array release];
}

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
	
	[self.activityManager startTaskWithTarget:self selector:@selector(asyncSave) object:nil];
	
}

- (void) asyncSave {
	
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	
	JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	
	[self.trip setName: self.tripName];
	
	if (self.cameraController.imageSelected != nil) {
		
		trip.photo.image = self.cameraController.imageSelected;
		trip.thumbNail = [ImageHelper image:self.cameraController.imageSelected fitInSize:CGSizeMake(88.0, 66.0)];
	}
	
	NSError *error;
	
	if (![aContext save: &error]) {
		
		[Logger logError:error withMessage:@"Failed to save destination"];
	}
	
	[self performSelectorOnMainThread:@selector(finishedSaving) withObject:nil waitUntilDone:NO]; 
	
	[aPool drain];
}

-(void) finishedSaving {
	
	[self.activityManager stopTask];
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
	
	NSString *titleName = nil;
	
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
		NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
	
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
		
		JauntAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

		if (self.editing == YES && indexPath.row == 0) {
			
			NSManagedObjectContext *aContext = [delegate getManagedObjectContext];
			
			Destination *aDestination = (Destination *) [NSEntityDescription insertNewObjectForEntityForName:@"Destination" inManagedObjectContext: aContext];
			aDestination.name = @"";
			aDestination.city = @"";
			aDestination.state = @"";
			
			controller.destination = aDestination;
			
			NSMutableSet *destinations = [self.trip mutableSetValueForKey:@"destinations"];
			[destinations addObject: aDestination];
			
		} else {
			
			controller.destination = [[self.trip.destinations allObjects] objectAtIndex:[self currentRowAtIndexPath:indexPath]];
		}
		
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
		
	[cameraController setDelegate: nil];
	[activityManager setView: nil];
	[cameraController release];
	[activityManager release];
	[titles release];
	[trip release];
	[tripName release];
	[cellManager release];
	[super dealloc];
}

@end
