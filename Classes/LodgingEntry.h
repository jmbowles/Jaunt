//
//  LodgingEntry.h
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleEntry.h"

@interface LodgingEntry : NSObject <GoogleEntry> {

	NSString *location;
	NSString *filter;
	NSString *name;
	NSString *itemType;
}

@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *itemType;

-(id) initWithLocation:(NSString *) aLocation withName:(NSString *) aName itemType:(NSString *) anItemType andFilter:(NSString *) aFilter;

@end
