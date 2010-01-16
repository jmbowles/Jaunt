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



#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	[self.mapView setDelegate:self];
	[self loadAnnotations];
	[self adjustMapRegion];
}

#pragma mark -
#pragma mark MapView

-(void) loadAnnotations {
	
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
			anAnnotation.title = aDestination.city;
			anAnnotation.subtitle = aDestination.state;
			
			[annotations addObject:anAnnotation];
			[anAnnotation release];
		}
	}
	[self.mapView addAnnotations:annotations];
}

-(void) adjustMapRegion {
	
	CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MapAnnotation *annotation in self.mapView.annotations)
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
    [super dealloc];
}

@end
