//
//  KeyValuePair.h
//  Jaunt
//
//  Created by John Bowles on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageKeyValue : NSObject {

	NSString *keyName;
	UIImage *imageValue;
}

@property (nonatomic, retain) NSString *keyName;
@property (nonatomic, retain) UIImage *imageValue;

@end
