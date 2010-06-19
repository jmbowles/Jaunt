//
//  ChecklistGroup.m
//  Jaunt
//
//  Created by John Bowles on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChecklistGroup.h"
#import "ChecklistItem.h"

@implementation ChecklistGroup

@dynamic name;
@dynamic checklistItems;

-(NSComparisonResult)compareName:(ChecklistGroup *) aTarget {
	
	return [self.name compare:aTarget.name];
}

-(BOOL) allItemsChecked {
	
	NSSet *items = [self checklistItems];
	BOOL allChecked = [items count] > 0 ? YES : NO;
	NSEnumerator *anEnumerator = [items objectEnumerator];
	ChecklistItem *item;
	
	while ((item = [anEnumerator nextObject])) {
		
		if ([item.checked intValue] == 0) {
			allChecked = NO;
			break;
		}
	}
	return allChecked;
}

@end
