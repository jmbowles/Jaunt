//
//  ChecklistGroup.h
//  Jaunt
//
//  Created by John Bowles on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSManagedObject.h>


@interface ChecklistGroup : NSManagedObject {
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *checklistItems;

-(NSComparisonResult)compareName:(ChecklistGroup *) aTarget;
-(BOOL) allItemsChecked;

@end
