//
//  Trip.h
//  Jaunt
//
//  Created by John Bowles on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/NSManagedObject.h>

@class Photo;

@interface Trip : NSManagedObject {
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *destinations;
@property (nonatomic, retain) UIImage *thumbNail;
@property (nonatomic, retain) Photo *photo;

@end
