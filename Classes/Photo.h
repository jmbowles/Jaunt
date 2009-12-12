//
//  Photo.h
//  Jaunt
//
//  Created by John Bowles on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/NSManagedObject.h>

@class Trip;


@interface Photo : NSManagedObject  
{
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) Trip *trip;

@end



