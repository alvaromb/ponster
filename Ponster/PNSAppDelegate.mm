//
//  PNSAppDelegate.m
//  Ponster
//
//  Created by alvaro on 28/10/13.
//  Copyright (c) 2013 alvaromb. All rights reserved.
//

#import "PNSAppDelegate.h"

@implementation PNSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Ponster.sqlite"];
    [self mockPosterData];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[PNSPostersViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)mockPosterData
{
    [Poster MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    Poster *poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"Back to the future";
    poster.imageUrl = @"BackToTheFuture.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"Alien";
    poster.imageUrl = @"Alien.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"Drive";
    poster.imageUrl = @"Drive.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"Saving Private Ryan";
    poster.imageUrl = @"SavingPrivateRyan.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"The Dark Knight";
    poster.imageUrl = @"TheDarkKnightRises.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"The Godfather";
    poster.imageUrl = @"TheGodfather.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"The Thin Red Line";
    poster.imageUrl = @"TheThinRedLine.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
    
    poster = [Poster MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    poster.title = @"Star Wars";
    poster.imageUrl = @"StarWars.jpg";
    poster.desc = @"";
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
}

@end
