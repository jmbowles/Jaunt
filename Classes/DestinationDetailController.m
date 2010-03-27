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
#import "RestaurantEntry.h"
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
	
	GoogleEntry *hotels = [[LodgingEntry alloc] initWithLocation:latLong withName:@"Hotels" itemType:@"hotels" andFilter:nil];
	GoogleEntry *bnb = [[LodgingEntry alloc] initWithLocation:latLong withName:@"Bed & Breakfast" itemType:@"Bed and Breakfast" andFilter:nil];
	GoogleEntry *food = [[RestaurantEntry alloc] initWithLocation:latLong withName:@"Restaurants" andFilter:nil];
	GoogleEntry *sightseeing = [[EventEntry alloc] initWithLocation:latLong withName:@"Sightseeing" andFilter:@"[event type:Sightseeing]"];
	GoogleEntry *concerts = [[EventEntry alloc] initWithLocation:latLong withName:@"Concerts" andFilter:@"[event type:Concerts]"];
	GoogleEntry *sports = [[EventEntry alloc] initWithLocation:latLong withName:@"Sports" andFilter:@"[event type:Sports]"];
	GoogleEntry *comedy = [[EventEntry alloc] initWithLocation:latLong withName:@"Comedy" andFilter:@"[event type:Comedy]"];
	GoogleEntry *arts = [[EventEntry alloc] initWithLocation:latLong withName:@"Performing Arts" andFilter:@"[event type:Performing/Visual Arts]"];
	
	NSArray *anArray = [[NSArray alloc] initWithObjects:hotels, bnb, food, sightseeing, concerts, sports, comedy, arts, nil];
	[self setActions: anArray];
	
	[anArray release];
	[hotels release];
	[bnb release];
	[food release];
	[sightseeing release];
	[concerts release];
	[sports release];
	[comedy release];
	[arts release];
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
