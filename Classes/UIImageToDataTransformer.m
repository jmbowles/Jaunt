//
//  UIImageToDataTransformer.m
//  Jaunt
//
//  Created by John Bowles on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIImageToDataTransformer.h"


@implementation UIImageToDataTransformer

+(BOOL) allowsReverseTransformation {
	
	return YES;
}

+(Class) transformedValueClass {
	
	return [NSData class];
}

-(id) transformedValue:(id)value {
	
	return UIImageJPEGRepresentation(value, 0.7);
}

-(id) reverseTransformedValue:(id)value {
	
	return [[[UIImage alloc] initWithData:value] autorelease];
}

@end

