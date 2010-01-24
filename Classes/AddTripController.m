//
//  AddTripController.m
//  Jaunt
//
//  Created by John Bowles on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddTripController.h"
#import "Trip.h"
#import "Photo.h"
#import "JauntAppDelegate.h"
#import	"CellManager.h"
#import "IndexedTextField.h"
#import	"TextFieldExtension.h"
#import "CellExtension.h"
#import	"Logger.h"
#import "ActivityManager.h"
#import "CameraController.h"
#import	"ViewManager.h"
#import	"ImageHelper.h"


@implementation AddTripController


@synthesize cameraController;
@synthesize activityManager;
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
	
	[self initializeDelegates];
	[self createHeader];
	[self loadCells];
}

-(void) createHeader {
	
	UIView *aHeaderView = [ViewManager viewWithPhotoButtonForTarget:self andAction:@selector(setTripImage:) usingTag:1 
							width:self.tableView.bounds.size.width height:100];
	
	self.tableView.tableHeaderView = aHeaderView;
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
	
	[self.cameraController selectImage];
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
	
	[self.activityManager startTaskWithTarget:self selector:@selector(asyncSave) object:nil];
}

- (void) asyncSave {
		
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *aContext = [aDelegate getManagedObjectContext];
	
	Photo *aPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext: aContext];
	aPhoto.image = self.cameraController.imageSelected;
	
	Trip *aTrip = (Trip *) [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext: aContext];
	[aTrip setName:self.tripName];
	[aTrip setPhoto:aPhoto];
	[aTrip setThumbNail:[ImageHelper image:self.cameraController.imageSelected fitInSize:CGSizeMake(88.0, 66.0)]];
	 
	NSError *error;
	
	if (![aContext save: &error]) {
		
		[Logger logError:error withMessage:@"Failed to add trip"];
	}
	
	[self performSelectorOnMainThread:@selector(finishedSaving) withObject:nil waitUntilDone:NO]; 
	
	[aPool release];
}

-(void) finishedSaving {

	[self.activityManager stopTask];
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
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
	
	[cameraController setDelegate: nil];
	[activityManager setView: nil];
	[cameraController release];
	[activityManager release];
	[tripName release];
	[cellManager release];
	[super dealloc];
}

@end
