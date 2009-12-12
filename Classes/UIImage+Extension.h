//
//  UIImage+Extension.h
//  Jaunt
//
//  Created by John Bowles on 12/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Extension)

+(UIImage*) imageWithImage:(UIImage*) anImage scaledToSize:(CGSize) newSize;

@end;