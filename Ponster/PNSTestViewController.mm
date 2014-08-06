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
@property (strong, nonatomic) UIImage *posterImage;

@end

@implementation PNSTestViewController

#pragma mark - Lazy instantiation

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.backgroundColor = [UIColor redColor];
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

- (instancetype)initWithImage:(UIImage *)posterImage
{
    NSParameterAssert(posterImage);
    if (self = [super init]) {
        self.posterImage = posterImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.backgroundImageView];
    
    // Configure Pattern Detector
    UIImage *trackerImage = [UIImage imageNamed:@"target"];
    _patternDetector = new PatternDetector([trackerImage toCVMat], [self.posterImage toCVMat]);
    
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // Invalidate timer and stop AVCaptureSession
    [self.trackingTimer invalidate];
    [self.imageCapture.captureSession stopRunning];
}

- (void)dealloc
{
    NSLog(@"%@ : dealloc", [self class]);
    delete _patternDetector;
    _imageCapture.delegate = nil;
    _imageCapture = nil;
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    self.backgroundImageView.frame = self.view.bounds;
}

#pragma mark - PNSImageCaptureDelegate

- (void)frameReady:(VideoFrame)frame
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        _patternDetector->scanFrame(frame);
    });
}

#pragma mark - Tracking timer

- (void)updateTracking:(NSTimer *)timer
{
    [self.backgroundImageView setImage:[UIImage fromCVMat:_patternDetector->sampleImage()]];
}

@end
