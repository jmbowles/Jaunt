//
//  JauntAppDelegate.h
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface JauntAppDelegate : NSObject <UIApplicationDelegate> {
    
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *rootController;
	IBOutlet UINavigationController *navigationController;

@private
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *rootController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

-(NSManagedObjectModel *) getManagedObjectModel;
-(NSManagedObjectContext *) getManagedObjectContext;
-(NSPersistentStoreCoordinator *) getPersistentStoreCoordinator;

@end