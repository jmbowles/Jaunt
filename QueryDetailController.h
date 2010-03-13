//
//  QueryDetailController.h
//  Jaunt
//
//  Created by John Bowles on 3/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoogleQuery;

@interface QueryDetailController : UIViewController {

	UITextView *textView;
	GoogleQuery *googleQuery;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) GoogleQuery *googleQuery;

@end
