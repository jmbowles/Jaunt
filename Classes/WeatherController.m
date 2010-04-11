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

@implementation WeatherController

@synthesize trip;
@synthesize forecasts;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	//Destination *destination = [[self.trip.destinations allObjects] objectAtIndex:0];
	
	[self setForecasts:[NSMutableArray array]];
	
	//NSString *ashville = [NSString stringWithFormat:@"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdBrowserClientByDay.php?listLatLon=%1.3f,%1.3f+%1.3f,%1.3f&format=24+hourly&numDays=7", [destination.latitude doubleValue], [destination.longitude doubleValue],[destination.latitude doubleValue], [destination.longitude doubleValue]];
	NSString *noaaUrl = [Forecast noaaUrlForDestinations:self.trip.destinations]; 
	[Logger logMessage:noaaUrl withTitle:@"NOAA Url"];
	
	NSURL *url = [NSURL URLWithString:noaaUrl];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark ASIHTTP Callbacks

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	[Logger logMessage:responseString withTitle:@"ASIResponse"];
	
	NSData *xmlData = [request responseData];
	
	NSError *error;
	GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	NSArray *locations = [aDocument nodesForXPath:@"//location" error:&error];
	NSDate *today = [NSDate date];
	int destinationIndex = 0;
	NSArray *destinations = [self.trip.destinations allObjects];
	
	for (GDataXMLElement *aLocation in locations) {
		
		GDataXMLElement *key = [[aLocation elementsForName:@"location-key"] objectAtIndex:0];
		GDataXMLElement *point = [[aLocation elementsForName:@"point"] objectAtIndex:0];
		NSString *latitude = [[point attributeForName:@"latitude"] stringValue];
		NSString *longitude = [[point attributeForName:@"longitude"] stringValue];
		
		Destination *aDestination = [destinations objectAtIndex:destinationIndex++];
		
		Forecast *aForecast = [[Forecast alloc] init];
		[aForecast setCity:aDestination.city];
		[aForecast setState:aDestination.state];
		[aForecast setLatitude:latitude];
		[aForecast setLongitude:longitude];
		
		int index = 1;
		
		for (int i=1; i <= 7; i++) {
			
			NSString *maxTempsXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='maximum']/value[position()=%i]", [key stringValue], i];
			NSString *minTempsXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='minimum']/value[position()=%i]", [key stringValue], i];
			NSString *maxTemp = [[[aDocument nodesForXPath:maxTempsXPath error:&error] objectAtIndex:0] stringValue];
			NSString *minTemp = [[[aDocument nodesForXPath:minTempsXPath error:&error] objectAtIndex:0] stringValue];
			
			NSString *precip1XPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/probability-of-precipitation/value[position()=%i]", [key stringValue], index];
			NSString *precip2XPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/probability-of-precipitation/value[position()=%i]", [key stringValue], index+1];
			int precip1 = [[[[aDocument nodesForXPath:precip1XPath error:&error] objectAtIndex:0] stringValue] intValue];
			int precip2 = [[[[aDocument nodesForXPath:precip2XPath error:&error] objectAtIndex:0] stringValue] intValue];
			int averageProbability = (precip1 + precip2) / 2;
			
			index +=2;
			
			NSCalendar *aCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents *components = [[NSDateComponents alloc] init];
			[components setDay:i];
			NSDate *aDate = [aCalendar dateByAddingComponents:components toDate:today options:0];
			[aCalendar release];
			[components release];
			
			ForecastDetail *aDetail = [[ForecastDetail alloc] init];
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
	[self.tableView reloadData];
	[aDocument release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	[Logger logError:error withMessage:@"Failed to fetch forecast"];
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
	
	ForecastDetail *todaysForecast = [aForecast todaysForecast];
	NSString *hiLow = [NSString stringWithFormat:@"High/Low: %@ / %@\u2070 F", todaysForecast.maxTemp, todaysForecast.minTemp];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  Precipitation: %@%%", hiLow, todaysForecast.probabilityOfPrecipitation];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	/**
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	self.selectedTrip = [self.tripsCollection objectAtIndex:indexPath.row];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Map", @"Weather", @"Checklist", @"Reservations", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 4;
	[actionSheet showInView: self.view];
	[actionSheet release];
	 **/
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[trip release];
	[forecasts release];
    [super dealloc];
}

@end
