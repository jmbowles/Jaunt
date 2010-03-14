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
}

@property (nonatomic, retain) NSString *location;

-(id) initWithLocation:(NSString *) aLocation;

@end
