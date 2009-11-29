//
//  CellManager.h
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellManager : NSObject {

@private
	NSArray *nibNames;
	NSArray *reusableIdentifiers;
	NSString *owner;
}

@property (nonatomic, retain) NSArray *nibNames;
@property (nonatomic, retain) NSArray *reusableIdentifiers;
@property (nonatomic, retain) NSString *owner;

-(id) init;
-(id) initWithNibs:(NSArray *) names withIdentifiers:(NSArray *) identifiers forOwner:(id) anOwner;

-(UITableViewCell *) cellForSection:(NSUInteger) section;
-(NSString *) reusableIdentifierForSection:(NSUInteger) section;

@end
