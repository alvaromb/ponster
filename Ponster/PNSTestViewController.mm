//
//  PNSTestViewController.m
//  Ponster
//
//  Created by alvaro on 30/10/13.
//  Copyright (c) 2013 alvaromb. All rights reserved.
//

#import "PNSTestViewController.h"

@interface PNSTestViewController ()
{
    PatternDetector *_patternDetector;
}

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) PNSImageCapture *imageCapture;
@property (strong, nonatomic) NSTimer *trackingTimer;

@end

@implementation PNSTestViewController

#pragma mark - Lazy instantiation

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.backgroundColor = [UIColor greenColor];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}

- (NSTimer *)trackingTimer
{
    if (!_trackingTimer) {
        _trackingTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/20.0f)
                                                          target:self
                                                        selector:@selector(updateTracking:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    return _trackingTimer;
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.backgroundImageView];
    
    // Configure Pattern Detector
    UIImage *trackerImage = [UIImage imageNamed:@"target"];
    UIImage *posterImage = [UIImage imageNamed:@"lena.jpg"];
    _patternDetector = new PatternDetector([trackerImage toCVMat], [posterImage toCVMat]);
    
    self.imageCapture = [[PNSImageCapture alloc] init];
    self.imageCapture.delegate = self;
    [self.imageCapture startWithDevicePosition:AVCaptureDevicePositionBack];
    
    // Start tracking
    [self.trackingTimer fire];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.backgroundImageView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.trackingTimer invalidate];
}

- (void)dealloc
{
    [self.trackingTimer invalidate];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    self.backgroundImageView.frame = self.view.bounds;
}

#pragma mark - PNSImageCaptureDelegate

- (void)frameReady:(VideoFrame)frame
{
//    __weak typeof(self) _weakSelf = self;
//    dispatch_sync( dispatch_get_main_queue(), ^{
//        // Construct CGContextRef from VideoFrame
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGContextRef newContext = CGBitmapContextCreate(frame.data,
//                                                        frame.width,
//                                                        frame.height,
//                                                        8,
//                                                        frame.bytesPerRow,
//                                                        colorSpace,
//                                                        kCGBitmapByteOrder32Little |
//                                                        kCGImageAlphaPremultipliedFirst);
//        
//        // Construct CGImageRef from CGContextRef
//        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
//        CGContextRelease(newContext);
//        CGColorSpaceRelease(colorSpace);
//        
//        // Construct UIImage from CGImageRef
//        UIImage *image = [UIImage imageWithCGImage:newImage];
////        UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
//        CGImageRelease(newImage);
//        [[_weakSelf backgroundImageView] setImage:image];
//    });
    _patternDetector->scanFrame(frame);
}

#pragma mark - Tracking timer

- (void)updateTracking:(NSTimer *)timer
{
    [self.backgroundImageView setImage:[UIImage fromCVMat:_patternDetector->sampleImage()]];
}

@end
