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
	NSString *query;
	NSString *address;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) NSString *address;

-(id) initWithTitle:(NSString *) aTitle andQuery:(NSString *) aQuery;
-(id) initWithTitle:(NSString *) aTitle andAddress:(NSString *) anAddress;

@end
