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
#include "opencv2/features2d/features2d.hpp"
#include "opencv2/nonfree/features2d.hpp"

class PatternDetector
{
#pragma mark -
#pragma mark Public Interface
public:
    // (1) Constructor
    PatternDetector(const cv::Mat& pattern, const cv::Mat& posterImage);
    
    // (2) Scan the input video frame
    void scanFrame(VideoFrame frame);
    void findPattern(cv::Mat queryImageGray, cv::Mat scaledPattern);
    cv::Mat surfPattern(VideoFrame frame);
    
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
    cv::Mat m_sampleImage;
    cv::Mat m_resizedPosterImage;
    cv::Mat m_posterDescriptors;
    
    // Keypoints
    std::vector<cv::KeyPoint> m_posterKeypoints;
    
    // Feature detection
    cv::SurfFeatureDetector m_detector;
    cv::SurfDescriptorExtractor m_extractor;
    cv::FlannBasedMatcher m_matcher;
    
    // Scale the pattern to several sizes
    cv::Mat m_patternImageGrayScaled;
    
    // (6) Supporting Members
    cv::Point m_matchPoint;
    int m_matchMethod;
    float m_matchValue;
    float m_matchThresholdValue;
    float m_scaleFactor;
};

#endif /* defined(__OpenCVTutorial__PatternDetector__) */
