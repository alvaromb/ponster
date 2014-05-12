//
//  UIImage+OpenCV.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

@interface UIImage (OpenCV)

#pragma mark -
#pragma mark Generate UIImage from cv::Mat
+ (UIImage*)fromCVMat:(const cv::Mat&)cvMat;

#pragma mark -
#pragma mark Generate cv::Mat from UIImage
+ (cv::Mat)toCVMat:(UIImage*)image;
- (cv::Mat)toCVMat;

@end
