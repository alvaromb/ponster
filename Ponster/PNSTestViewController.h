//
//  PNSTestViewController.h
//  Ponster
//
//  Created by alvaro on 30/10/13.
//  Copyright (c) 2013 alvaromb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>

@interface PNSTestViewController : UIViewController

@property (strong, nonatomic) CvVideoCamera *videoCamera;

@end
