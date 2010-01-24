//
//  UIImage+Extension.m
//  Jaunt
//
//  Created by John Bowles on 12/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extension.h"


@implementation UIImage (Extension)


+(UIImage*) imageWithImage:(UIImage*) anImage scaledToSize:(CGSize) newSize {
	
	UIGraphicsBeginImageContext(newSize);
	[anImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

@end;
