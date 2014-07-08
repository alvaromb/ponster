//
//  PNSTestViewController.h
//  Ponster
//
//  Created by alvaro on 30/10/13.
//  Copyright (c) 2013 alvaromb. All rights reserved.
//

#import "PNSImageCapture.h"
#import "PatternDetector.h"
#import "UIImage+OpenCV.h"

@interface PNSTestViewController : UIViewController <PNSImageCaptureDelegate>

- (instancetype)initWithImage:(UIImage *)posterImage;

@end
