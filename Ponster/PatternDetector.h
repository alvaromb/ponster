//
//  PatternDetector.h
//  Ponster
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#ifndef __OpenCVTutorial__PatternDetector__
#define __OpenCVTutorial__PatternDetector__

#include "VideoFrame.h"

class PatternDetector
{
#pragma mark -
#pragma mark Public Interface
public:
    // (1) Constructor
    PatternDetector(const cv::Mat& pattern);
    
    // (2) Scan the input video frame
    void scanFrame(VideoFrame frame);
    
    // (3) Match APIs
    const cv::Point& matchPoint();
    float matchValue();
    float matchThresholdValue();
    
    // (4) Tracking API
    bool isTracking();
    
    const cv::Mat& sampleImage();
    
#pragma mark -
#pragma mark Private Members
private:
    // (5) Reference Marker Images
    cv::Mat m_patternImage;
    cv::Mat m_patternImageGray;
    cv::Mat m_patternImageGrayScaled;
    cv::Mat m_sampleImage;
    
    // (6) Supporting Members
    cv::Point m_matchPoint;
    int m_matchMethod;
    float m_matchValue;
    float m_matchThresholdValue;
    float m_scaleFactor;
};

#endif /* defined(__OpenCVTutorial__PatternDetector__) */
