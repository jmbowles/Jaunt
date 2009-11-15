//
//  CellManager.h
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface CellManager : NSObject {

@private
	NSMutableArray *nibs;
}

@property (nonatomic, retain) NSMutableArray *nibs;

-(id) initWithNibs:(NSArray *) nibNames forOwner:(id) anOwner;
-(UITableViewCell *) cellForSection:(NSUInteger) section;

@end
