//
//  ViewManager.h
//  Jaunt
//
//  Created by John Bowles on 12/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewManager : NSObject {

}

+(UIView *) viewWithPhotoButtonForTarget:(id) aTarget andAction:(SEL) anAction usingTag:(NSInteger) 
			 aTag width:(CGFloat) aWidth height:(CGFloat) aHeight;

@end
