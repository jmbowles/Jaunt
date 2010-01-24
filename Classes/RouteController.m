//
//  RouteController.m
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RouteController.h"
#import	"Destination.h"
#import "MapAnnotation.h"
#import "Trip.h"
#import "Destination.h"
#import "ChecklistController.h"
#import "JauntAppDelegate.h"


@implementation RouteController

@synthesize mapView;
@synthesize trip;
@synthesize locationManager;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	CLLocationManager *aLocationManager = [[CLLocationManager alloc] init];
	aLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	aLocationManager.distanceFilter = kCLDistanceFilterNone;
	aLocationManager.delegate = self;
	self.locationManager = aLocationManager;
	[aLocationManager release];

	if (self.locationManager.locationServicesEnabled == YES)
	{
		[self.locationManager startUpdatingLocation];
		
		UIBarButtonItem *aRefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(performRefresh)];
		self.navigationItem.rightBarButtonItem = aRefreshButton;
		[aRefreshButton release];
		
	} else {
		
		[self loadAnnotations:nil];
	}
		
	[self.mapView setDelegate:self];
}

-(void) performRefresh {
	
	[self.locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark Core Location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	[self loadAnnotations:newLocation];
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	if (error.code == kCLErrorDenied) {
		
		[self.locationManager stopUpdatingLocation];
	}
}

#pragma mark -
#pragma mark MapView

-(void) loadAnnotations:(CLLocation *)aCurrentLocation {

	NSMutableArray *annotations = [NSMutableArray array];
	
	NSEnumerator *anIterator = [self.trip.destinations objectEnumerator];
	Destination *aDestination;
	
	while ((aDestination = [anIterator nextObject])) {
		
		double latitude = [aDestination.latitude doubleValue];
		double longitude = [aDestination.longitude doubleValue];
		
		if (fabs(latitude) > 0 && fabs(longitude) > 0) {
			
			CLLocationCoordinate2D aCoordinate;
			aCoordinate.latitude = latitude;
			aCoordinate.longitude = longitude;
			
			MapAnnotation *anAnnotation = [[MapAnnotation alloc] initWithCoordinate:aCoordinate];
			anAnnotation.title = [NSString stringWithFormat:@"%@, %@", aDestination.city, aDestination.state];
			anAnnotation.subtitle = [self titleFromCurrentLocation:aCurrentLocation toDestination:aDestination];

			[annotations addObject:anAnnotation];
			[anAnnotation release];
		}
	}
	[self.mapView addAnnotations:annotations];
	[self adjustMapRegion];
}

-(NSString *) titleFromCurrentLocation:(CLLocation *) aCurrentLocation toDestination:(Destination *) aDestination {

	NSString *aTitle = @"";
	
	if (aCurrentLocation != nil) {
		
		NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
		[aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[aNumberFormatter setMaximumFractionDigits:1];
		
		double latitude = [aDestination.latitude doubleValue];
		double longitude = [aDestination.longitude doubleValue];
		
		CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		CLLocationDistance miles = ([aCurrentLocation getDistanceFrom:aLocation] * 3.28f) / 5280;
		[aLocation release];
		
		NSString *mileage = [aNumberFormatter stringFromNumber:[NSNumber numberWithDouble:miles]];
		aTitle = [NSString stringWithFormat:@"Miles: %@", mileage];
		
		double mph = ([aCurrentLocation speed] * 3.28 * 3600) / 5280;
		
		if (mph > 0) {
			
			double hours = miles / mph;
			NSString *totalHours = [aNumberFormatter stringFromNumber:[NSNumber numberWithDouble:hours]];
			aTitle = [NSString stringWithFormat:@"Miles: %@, Hours: %@", mileage, totalHours];
		}
		[aNumberFormatter release];
	}
	return aTitle;
}

-(void) adjustMapRegion {
	
	CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (MapAnnotation *annotation in self.mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; 
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

#pragma mark -
#pragma mark MapView Delegates

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
	for (MKPinAnnotationView *aView in views)
	{
		aView.pinColor = MKPinAnnotationColorRed;
		aView.animatesDrop = YES;
		UIButton *aButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		aView.rightCalloutAccessoryView = aButton;
	}
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	ChecklistController *aController = [[ChecklistController alloc] initWithNibName:@"Checklist" bundle:[NSBundle mainBundle]];
	aController.title = @"Journal";
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[mapView release];
	[trip release];
	[locationManager release];
    [super dealloc];
}

@end
