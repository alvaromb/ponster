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
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/nonfree/nonfree.hpp"
#include <opencv2/objdetect/objdetect.hpp>
//#include "opencv2/nonfree/gpu.hpp"

using namespace cv;
using namespace std;
using namespace gpu;

class PatternDetector
{
#pragma mark -
#pragma mark Public Interface
public:
    // (1) Constructor
    PatternDetector(const Mat& pattern, const Mat& posterImage);
    
    // (2) Scan the input video frame
    void scanFrame(VideoFrame frame);
    void findPattern(Mat queryImageGray, Mat scaledPattern);
    Mat surfPattern(VideoFrame frame);
    Mat fastDetection(VideoFrame frame);
    
    // (3) Match APIs
    const cv::Point& matchPoint();
    float matchValue();
    float matchThresholdValue();
    
    // (4) Tracking API
    bool isTracking();
    
    const Mat& sampleImage();
    
#pragma mark -
#pragma mark Private Members
private:
    // (5) Reference Marker Images
    cv::Mat m_patternImage;
    cv::Mat m_sampleImage;
    cv::Mat m_resizedPosterImage;
    cv::Mat m_posterDescriptors;
    
    // Keypoints
    vector<KeyPoint> m_posterKeypoints;
    
    // Feature detection
    SurfFeatureDetector m_surf_detector;
//    SURF_GPU m_surf_gpu;
    OrbFeatureDetector m_detector;
//    cv::SurfDescriptorExtractor m_extractor;
    OrbDescriptorExtractor m_extractor;
    FREAK m_freak;
//    cv::FastFeatureDetector m_detector;
    FlannBasedMatcher m_matcher;
    BFMatcher m_bfmatcher;
    
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
