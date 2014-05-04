//
//  PNSImageCapture.m
//  Ponster
//
//  Created by Álvaro on 04/05/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import "PNSImageCapture.h"

@implementation PNSImageCapture

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        if ([captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
            NSLog(@"640x480 capture session");
        }
        else {
            NSLog(@"Error configuring capture session");
        }
        _captureSession = captureSession;
    }
    return self;
}

- (void)dealloc
{
    [_captureSession stopRunning];
}

#pragma mark - Public interface

- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition
{
    // Configure capture device for devicePosition
    AVCaptureDevice *captureDevice = [self cameraWithPosition:devicePosition];
    if (nil == captureDevice) {
        NSLog(@"");
        return NO;
    }
    
    // Configure capture input
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"");
        return NO;
    }
    
    // Set input for capture session
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    else {
        NSLog(@"");
        return NO;
    }
    
    // Configure output
    [self configureVideoOutput];
    
    // Start capture
    [self.captureSession startRunning];
    
    return YES;
}

#pragma mark - Helper Methods

- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)configureVideoOutput
{
    // Instantiate a new video data output object
    AVCaptureVideoDataOutput * captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // The sample buffer delegate requires a serial dispatch queue
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.ponster.opencv", DISPATCH_QUEUE_SERIAL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    // Define the pixel format for the video data output
    NSString * key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber * value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary * settings = @{key:value};
    [captureOutput setVideoSettings:settings];
    
    // Configure the output port on the captureSession property
    [self.captureSession addOutput:captureOutput];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Convert CMSampleBufferRef to CVImageBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    // Construct VideoFrame struct
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t stride = CVPixelBufferGetBytesPerRow(imageBuffer);
    VideoFrame frame = {width, height, stride, baseAddress};
    
    // Dispatch VideoFrame to VideoSource delegate
    [self.delegate frameReady:frame];
    
    // Unlock pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

@end
