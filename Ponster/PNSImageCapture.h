//
//  PNSImageCapture.h
//  Ponster
//
//  Created by Álvaro on 04/05/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VideoFrame.h"

#pragma mark - PNSImageCaptureProtocol

@protocol PNSImageCaptureDelegate <NSObject>

@required
- (void)frameReady:(VideoFrame)frame;

@end

#pragma mark - PNSImageCapture interface

@interface PNSImageCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (weak, nonatomic) id<PNSImageCaptureDelegate> delegate;

- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition;

@end
