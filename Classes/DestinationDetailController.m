//
//  DestinationDetailController.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DestinationDetailController.h"
#import "GDataGoogleBase.h"
#import "GoogleServices.h"
#import "GoogleEntry.h"
#import "LodgingEntry.h"
#import "EventEntry.h"
#import "Destination.h"
#import "QueryResultController.h"
#import "JauntAppDelegate.h"


@interface DestinationDetailController (PrivateMethods) 

-(void) loadActions;

@end


@implementation DestinationDetailController

@synthesize destination;
@synthesize currentLocation;
@synthesize actions;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
	[self loadActions];
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.actions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"ActionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	GoogleEntry *anEntry = [self.actions objectAtIndex: [indexPath row]];
	cell.textLabel.text = [anEntry getTitle];	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}


- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	GoogleEntry *anEntry = [self.actions objectAtIndex:indexPath.row];
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	QueryResultController *aController = [[QueryResultController alloc] init];
	
	[aController setTitle:[anEntry getTitle]];
	[aController setGoogleEntry:anEntry];
	[aController setCurrentLocation: self.currentLocation];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark Private Methods

-(void) loadActions {
	
	NSString *latLong = [GoogleServices formatLatitude:self.destination.latitude andLongitude:self.destination.longitude];
	GoogleEntry *lodging = [[LodgingEntry alloc] initWithLocation:latLong];
	GoogleEntry *events = [[EventEntry alloc] initWithLocation:latLong];
	NSArray *anArray = [[NSArray alloc] initWithObjects:lodging, events, nil];
	[self setActions: anArray];
	[anArray release];
	[lodging release];
	[events release];
}


#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[destination release];
	[currentLocation release];
	[actions release];
	[super dealloc];
}

@end
