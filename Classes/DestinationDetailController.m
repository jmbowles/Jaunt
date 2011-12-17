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
@synthesize places;
@synthesize actions;
@synthesize icons;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
    
    NSString *placeTypes = [[NSBundle mainBundle] pathForResource:@"Places" ofType:@"plist"];
    self.places = [NSArray arrayWithContentsOfFile:placeTypes];
    
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
	NSMutableArray *placesArray = [NSMutableArray array];
    NSMutableArray *iconsArray = [NSMutableArray array];
    
    for (NSDictionary *aDictionary in self.places) {
        
        NSString *title = [aDictionary objectForKey:@"Title"];
        NSString *imageName = [aDictionary objectForKey:@"ImageName"];
        NSString *type = [aDictionary objectForKey:@"Type"];
        NSString *filter = [aDictionary objectForKey:@"Filter"];
        NSInteger radius = [[aDictionary objectForKey:@"Radius"] intValue];
        
        GooglePlaceRequest *aRequest = [[GooglePlaceRequest alloc] initWithPlace:latLong title:title placeType:type placeFilter:filter defaultImage:imageName radius:radius currentLocation:self.currentLocation];
        
        [placesArray addObject:aRequest];
        [self setActions: placesArray];
        [aRequest release];
        
        [iconsArray addObject:[UIImage imageNamed:imageName]];
        [self setIcons: iconsArray];
    }
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[destination release];
	[currentLocation release];
    [places release];
	[actions release];
	[icons release];
	[super dealloc];
}

@end
