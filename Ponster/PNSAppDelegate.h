//
//  PNSAppDelegate.h
//  Ponster
//
//  Created by alvaro on 28/10/13.
//  Copyright (c) 2013 alvaromb. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PNSTestViewController.h"
#import "PNSPostersViewController.h"

@interface PNSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
