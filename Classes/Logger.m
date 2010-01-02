//
//  Logger.m
//  Jaunt
//
//  Created by John Bowles on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Logger.h"


@implementation Logger

+(void) logError:(NSError*) anError withMessage:(NSString*) aMessage {
	
	NSLog(@"%@: %@", aMessage, [anError localizedDescription]);
	NSArray* detailedErrors = [[anError userInfo] objectForKey:NSDetailedErrorsKey];
	
	if(detailedErrors != nil && [detailedErrors count] > 0) {
		
		for(NSError* detailedError in detailedErrors) {
			NSLog(@"  DetailedError: %@", [detailedError userInfo]);
		}
	}
	else {
		NSLog(@"  %@", [anError userInfo]);
	}
}
	
+(void) logMessage:(NSString*) aMessage withTitle:(NSString *) aTitle {
	
	NSLog(@"%@: %@", aTitle, aMessage);
}

@end
