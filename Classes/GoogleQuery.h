//
//  GoogleQuery.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoogleQuery : NSObject {

	NSString *itemType;
	NSString *title;
	NSString *query;
	NSString *address;
	NSString *price;
	NSString *detailedDescription;
	NSString *href;
	NSString *mapsURL;
}

@property (nonatomic, retain) NSString *itemType;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *detailedDescription;
@property (nonatomic, retain) NSString *href;
@property (nonatomic, retain) NSString *mapsURL;

-(id) initWithTitle:(NSString *) aTitle andQuery:(NSString *) aQuery;
-(id) initWithTitle:(NSString *) aTitle andAddress:(NSString *) anAddress;

@end
