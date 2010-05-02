//
//  WeatherDetailController.h
//  Jaunt
//
//  Created by John Bowles on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Forecast;

@interface WeatherDetailController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

	Forecast *forecast;
	NSMutableDictionary *iconDictionary;
}

@property (nonatomic, retain) Forecast *forecast;
@property (nonatomic, retain) NSMutableDictionary *iconDictionary;

@end
