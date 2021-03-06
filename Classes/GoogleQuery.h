//
//  GoogleQuery.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoogleQuery : NSObject {

	NSString *title;
	NSString *subTitle;
	NSString *detailedDescription;
	NSString *address;
	NSString *href;
	NSString *mapsURL;
    NSString *iconHref;
    NSString *placeReference;
    NSString *phoneNumber;
    NSString *website;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, retain) NSString *detailedDescription;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *href;
@property (nonatomic, retain) NSString *mapsURL;
@property (nonatomic, retain) NSString *iconHref;
@property (nonatomic, retain) NSString *placeReference;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *website;

-(NSComparisonResult)compareQuery:(GoogleQuery *) aQuery;
+(NSString *) formatDateTimeRangeFromStartingDate:(NSDate *) startingDate andEndingDate:(NSDate *) endingDate;

@end
