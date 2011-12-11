//
//  DestinationDetailController.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//

#import "DestinationDetailController.h"
#import "GData.h"
#import "GoogleServices.h"
#import "Destination.h"
#import "QueryResultController.h"
#import "JauntAppDelegate.h"
#import "GooglePlaceRequest.h"


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
	
	GooglePlaceRequest *aPlaceRequest = [self.actions objectAtIndex: [indexPath row]];
	cell.textLabel.text = aPlaceRequest.title;	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = [self.icons objectAtIndex: [indexPath row]];
	
	return cell;
}


- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	GooglePlaceRequest *aPlaceRequest = [self.actions objectAtIndex:indexPath.row];
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	QueryResultController *aController = [[QueryResultController alloc] init];
	
	[aController setTitle:aPlaceRequest.title];
	[aController setPlaceRequest:aPlaceRequest];
	[aController setCurrentLocation: self.currentLocation];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark Private Methods

-(void) loadActions {
	
	NSString *latLong = [GoogleServices formatLatitude:self.destination.latitude andLongitude:self.destination.longitude];
	
    GooglePlaceRequest *hotels = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Hotels" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
    
    GooglePlaceRequest *bnb = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Bed & Breakfast" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
    
    GooglePlaceRequest *food = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Restaurants" placeType:@"restaurant" radius:5000 currentLocation:self.currentLocation];
	
    GooglePlaceRequest *sightseeing = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Sightseeing" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
    
    GooglePlaceRequest *concerts = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Concerts" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
    
    GooglePlaceRequest *sports = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Sports" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
    
    GooglePlaceRequest *comedy = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Comedy" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
    
    GooglePlaceRequest *arts = [[GooglePlaceRequest alloc] initWithPlace:latLong title:@"Performing Arts" placeType:@"restaurant" radius:500 currentLocation:self.currentLocation];
	
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
