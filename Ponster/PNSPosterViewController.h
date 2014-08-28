//
//  PNSPosterViewController.h
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "Poster.h"
#import "PNSTestViewController.h"
#import "SampleAppAboutViewController.h"
#import "SampleAppSlidingMenuController.h"
#import "UserDefinedTargetsViewController.h"

@interface PNSPosterViewController : UIViewController

- (instancetype)initWithPosterID:(NSManagedObjectID *)posterObjectID;

@end
