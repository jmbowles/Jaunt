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
-(void) loadIcons;

@end


@implementation DestinationDetailController

@synthesize destination;
@synthesize currentLocation;
@synthesize actions;
@synthesize icons;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
	[self loadActions];
	[self loadIcons];
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
	cell.imageView.image = [self.icons objectAtIndex: [indexPath row]];
	
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
	
	GoogleEntry *hotels = [[LodgingEntry alloc] initWithLocation:latLong withName:@"Hotels" itemType:@"hotels" andFilter:nil andCurrentLocation: self.currentLocation];
	GoogleEntry *bnb = [[LodgingEntry alloc] initWithLocation:latLong withName:@"Bed & Breakfast" itemType:@"Bed and Breakfast" andFilter:nil andCurrentLocation: self.currentLocation];
	GoogleEntry *food = [[RestaurantEntry alloc] initWithLocation:latLong withName:@"Restaurants" andFilter:nil andCurrentLocation: self.currentLocation];
	GoogleEntry *sightseeing = [[EventEntry alloc] initWithLocation:latLong withName:@"Sightseeing" andFilter:@"[event type:Sightseeing]" andCurrentLocation: self.currentLocation];
	GoogleEntry *concerts = [[EventEntry alloc] initWithLocation:latLong withName:@"Concerts" andFilter:@"[event type:Concerts]" andCurrentLocation: self.currentLocation];
	GoogleEntry *sports = [[EventEntry alloc] initWithLocation:latLong withName:@"Sports" andFilter:@"[event type:Sports]" andCurrentLocation: self.currentLocation];
	GoogleEntry *comedy = [[EventEntry alloc] initWithLocation:latLong withName:@"Comedy" andFilter:@"[event type:Comedy]" andCurrentLocation: self.currentLocation];
	GoogleEntry *arts = [[EventEntry alloc] initWithLocation:latLong withName:@"Performing Arts" andFilter:@"[event type:Performing/Visual Arts]" andCurrentLocation: self.currentLocation];
	
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

-(void) loadIcons {
	
	UIImage *hotels = [UIImage imageNamed:@"hotel.png"];
	UIImage *bnb = [UIImage imageNamed:@"bednbreakfast.png"];
	UIImage *food = [UIImage imageNamed:@"food.png"];
	UIImage *sightseeing = [UIImage imageNamed:@"sightseeing.png"];
	UIImage *concerts = [UIImage imageNamed:@"concerts.png"];
	UIImage *sports = [UIImage imageNamed:@"football.png"];
	UIImage *comedy = [UIImage imageNamed:@"comedy.png"];
	UIImage *arts = [UIImage imageNamed:@"arts.png"];

	NSArray *anArray = [[NSArray alloc] initWithObjects:hotels, bnb, food, sightseeing, concerts, sports, comedy, arts, nil];
	[self setIcons: anArray];
}


#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[destination release];
	[currentLocation release];
	[actions release];
	[icons release];
	[super dealloc];
}

@end
