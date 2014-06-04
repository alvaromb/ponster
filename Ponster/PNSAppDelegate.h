//
//  PNSAppDelegate.h
//  Ponster
//
//  Created by alvaro on 28/10/13.
//  Copyright (c) 2013 alvaromb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNSTestViewController.h"

@interface PNSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
