//
//  Logger.h
//  Jaunt
//
//  Created by John Bowles on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Logger : NSObject {

}

+(void) logError:(NSError*) anError withMessage:(NSString*) aMessage;
+(void) logMessage:(NSString*) aMessage withTitle:(NSString *) aTitle;

@end
