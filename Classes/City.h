//
//  City.h
//  Jaunt
//
//  Created by John Bowles on 12/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/NSManagedObject.h>

@interface City : NSManagedObject {

}

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *stateCode;

@end
