//
//  WeatherController.m
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WeatherController.h"
#import "GDataXMLNode.h"
#import "Trip.h"
#import "Destination.h"
#import "ASIHTTPRequest.h"
#import "Logger.h"
#import "DateUtils.h"
#import "Forecast.h";
#import "ForecastDetail.h"
#import "ActivityManager.h"
#import "WeatherDetailController.h"
#import "JauntAppDelegate.h"

@implementation WeatherController

@synthesize trip;
@synthesize forecasts;
@synthesize activityManager;
@synthesize iconDictionary;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	ActivityManager *anActivityManager = [[ActivityManager alloc] initWithView:self.tableView];
	self.activityManager = anActivityManager;
	[anActivityManager release];
	
	[self setForecasts:[NSMutableArray array]];
	[self setIconDictionary:[NSMutableDictionary dictionary]];
	
	[self.activityManager showActivity];
	
	NSURL *url = [NSURL URLWithString:[Forecast noaaUrlForDestinations:self.trip.destinations]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTP Callbacks

- (void) downloadImage:(NSString *) urlString
{
    NSAutoreleasePool *pool  = [[NSAutoreleasePool alloc] init];
	
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
	UIImage *anImage = [[UIImage alloc] initWithData:data];
    [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:anImage waitUntilDone:YES];
    [anImage release];
    [pool drain];
}

- (void)downloadImageOnThread:(NSString *)url
{
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:url];
}

- (void)imageLoaded:(UIImage *)anImage withName:(NSString *) aName
{
	// this wont work because of the second value
    [self.iconDictionary setValue:anImage forKey:aName];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[Logger logMessage:[request responseString] withTitle:@"NOAA Response"];
	
	NSData *xmlData = [request responseData];
	NSError *error;
	GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	NSArray *locations = [aDocument nodesForXPath:@"//location" error:&error];
	NSArray *icons = [aDocument nodesForXPath:@"//conditions-icon/icon-link" error:&error];
	
	for(GDataXMLElement *anIcon in icons) {
		
		if ([self.iconDictionary objectForKey:[anIcon stringValue]] == nil) {
			
			NSURL *url = [NSURL URLWithString:[anIcon stringValue]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *anImage = [[UIImage alloc] initWithData:data];
			[self.iconDictionary setValue:anImage forKey:[anIcon stringValue]];
			[anImage release];
		}
	}
		
	NSDate *today = [NSDate date];
	int destinationIndex = 0;
	NSArray *destinations = [self.trip.destinations allObjects];
	
	for (GDataXMLElement *aLocation in locations) {
		
		GDataXMLElement *key = [[aLocation elementsForName:@"location-key"] objectAtIndex:0];
		GDataXMLElement *point = [[aLocation elementsForName:@"point"] objectAtIndex:0];
		NSString *latitude = [[point attributeForName:@"latitude"] stringValue];
		NSString *longitude = [[point attributeForName:@"longitude"] stringValue];
		NSString *iconXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/conditions-icon/icon-link[1]", [key stringValue]];
		NSString *iconName = [[[aDocument nodesForXPath:iconXPath error:&error] objectAtIndex:0] stringValue];
		
		Destination *aDestination = [destinations objectAtIndex:destinationIndex++];
		
		Forecast *aForecast = [[Forecast alloc] init];
		[aForecast setImage:[self.iconDictionary objectForKey:iconName]];
		[aForecast setCity:aDestination.city];
		[aForecast setState:aDestination.state];
		[aForecast setCurrentTemperature:[Forecast currentTemperatureForDestination:aDestination]];
		[aForecast setLatitude:latitude];
		[aForecast setLongitude:longitude];
		
		int index = 1;
		int dateIndex = 0;
		
		for (int i=1; i <= 7; i++) {

			NSString *summaryXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/weather/weather-conditions[position()=%i]", [key stringValue], i];
			GDataXMLElement *condition = [[aDocument nodesForXPath:summaryXPath error:&error] objectAtIndex:0];
			NSString *summary = [[condition attributeForName:@"weather-summary"] stringValue];
			
			NSString *maxTempsXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='maximum']/value[position()=%i]", [key stringValue], i];
			NSString *minTempsXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='minimum']/value[position()=%i]", [key stringValue], i];
			NSString *maxTemp = [[[aDocument nodesForXPath:maxTempsXPath error:&error] objectAtIndex:0] stringValue];
			NSString *minTemp = [[[aDocument nodesForXPath:minTempsXPath error:&error] objectAtIndex:0] stringValue];
			
			NSString *precip1XPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/probability-of-precipitation/value[position()=%i]", [key stringValue], index];
			NSString *precip2XPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/probability-of-precipitation/value[position()=%i]", [key stringValue], index+1];
			int precip1 = [[[[aDocument nodesForXPath:precip1XPath error:&error] objectAtIndex:0] stringValue] intValue];
			int precip2 = [[[[aDocument nodesForXPath:precip2XPath error:&error] objectAtIndex:0] stringValue] intValue];
			int averageProbability = (precip1 + precip2) / 2;
			
			NSString *iconDetailXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/conditions-icon/icon-link[position()=%i]", [key stringValue], i];
			NSString *iconDetailName = [[[aDocument nodesForXPath:iconDetailXPath error:&error] objectAtIndex:0] stringValue];
			
			index +=2;
			
			NSCalendar *aCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents *components = [[NSDateComponents alloc] init];
			[components setDay: dateIndex++];
			NSDate *aDate = [aCalendar dateByAddingComponents:components toDate:today options:0];
			[aCalendar release];
			[components release];
			
			ForecastDetail *aDetail = [[ForecastDetail alloc] init];
			[aDetail setImage:[self.iconDictionary objectForKey:iconDetailName]];
			[aDetail setSummary:summary];
			[aDetail setDate:aDate];
			[aDetail setDayOfWeek:[DateUtils dayOfWeek:aDate]];
			[aDetail setMaxTemp:maxTemp];
			[aDetail setMinTemp:minTemp];
			[aDetail setProbabilityOfPrecipitation:[NSString stringWithFormat:@"%i", averageProbability]]; 
			
			[aForecast.forecastDetails addObject:aDetail];
			[aDetail release];
			
		}
		[self.forecasts addObject:aForecast];
		[aForecast release];
	}
	[self.forecasts sortUsingSelector:@selector(compareCity:)];
	[self.activityManager hideActivity];
	
	[self.tableView reloadData];
	[aDocument release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.activityManager hideActivity];
	
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Weather Status" message:@"Unable to fetch current weather data"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.forecasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"ForecastCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	Forecast *aForecast = [self.forecasts objectAtIndex: [indexPath row]];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", aForecast.city, aForecast.state];	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Temperature: %@\u2070 F", aForecast.currentTemperature];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = aForecast.image;
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	Forecast *aForecast = [self.forecasts objectAtIndex:indexPath.row];
	
	WeatherDetailController	*aController = [[WeatherDetailController alloc] initWithStyle: UITableViewStylePlain];
	aController.title = [NSString stringWithFormat:@"%@, %@", aForecast.city, aForecast.state];
	aController.forecast = aForecast;
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[trip release];
	[forecasts release];
	[activityManager release];
	[iconDictionary release];
    [super dealloc];
}

@end
