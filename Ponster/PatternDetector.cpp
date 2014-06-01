//
//  PatternDetector.cpp
//  Ponster
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#include "PatternDetector.h"

const float kDefaultScaleFactor     = 2.00f;
const float k50ScaleFactor          = 4.00f;
const float kDefaultThresholdValue  = 0.50f;

PatternDetector::PatternDetector(const cv::Mat& patternImage, const cv::Mat& posterImage)
{
    m_scaleFactor = kDefaultScaleFactor;
    
    // (1) Save the pattern image
    m_patternImage = patternImage;
    
    // Set the poster image
    cv::resize(posterImage, m_resizedPosterImage, cv::Size(posterImage.rows/m_scaleFactor, posterImage.cols/m_scaleFactor));
    
    // (2) Create a grayscale version of the pattern image
    switch ( patternImage.channels() )
    {
        case 4: /* 3 color channels + 1 alpha */
            cv::cvtColor(m_patternImage, m_patternImageGray, CV_RGBA2GRAY);
            break;
        case 3: /* 3 color channels */
            cv::cvtColor(m_patternImage, m_patternImageGray, CV_RGB2GRAY);
            break;
        case 1: /* 1 color channel, grayscale */
            m_patternImageGray = m_patternImage;
            break;
    }
    
    // (3) Create several sizes to make the algorithm scale-invariant
    float h = m_patternImageGray.rows / m_scaleFactor;
    float w = m_patternImageGray.cols / m_scaleFactor;
    cv::resize(m_patternImageGray, m_patternImageGrayScaled, cv::Size(w, h));
    
    h = m_patternImageGray.rows / k50ScaleFactor;
    w = m_patternImageGray.cols / k50ScaleFactor;
    cv::resize(m_patternImageGray, m_patternImageGrayScaled50, cv::Size(w, h));
    
    // (4) Configure the tracking parameters
    m_matchThresholdValue = kDefaultThresholdValue;
    m_matchMethod = CV_TM_CCOEFF_NORMED;
}

void PatternDetector::scanFrame(VideoFrame frame)
{
    // (1) Build the grayscale query image from the camera data
    cv::Mat queryImageGray, outputImage, selectedPattern;
    cv::Mat queryImage = cv::Mat(frame.height, frame.width, CV_8UC4, frame.data, frame.bytesPerRow);
    cv::cvtColor(queryImage, queryImageGray, CV_BGR2GRAY);
    cv::cvtColor(queryImage, outputImage, CV_BGR2BGRA);
    
    float selectedScaleFactor = m_scaleFactor;
    selectedPattern = m_patternImageGrayScaled;
    PatternDetector::findPattern(queryImageGray, selectedPattern);
    if (!PatternDetector::isTracking()) {
        selectedScaleFactor = k50ScaleFactor;
        selectedPattern = m_patternImageGrayScaled50;
        PatternDetector::findPattern(queryImageGray, selectedPattern);
    }
    
    if (PatternDetector::isTracking()) {
        // Compute the rescaled origin of the detection
        cv::Point rescaledPoint = m_matchPoint * m_scaleFactor; //selectedScaleFactor;
        
//        if (selectedScaleFactor == k50ScaleFactor) {
//            printf("detecting with k50ScaleFactor");
//        }

        // Overlay a rectangle
//        cv::Point rectanglePoint = cv::Point(rescaledPoint.x + (selectedPattern.cols * m_scaleFactor), rescaledPoint.y + (selectedPattern.rows * m_scaleFactor));
//        cv::rectangle(outputImage, rescaledPoint, rectanglePoint, CV_RGB(0, 0, 0), 3);
        
        // Overlay poster image
        cv::Point rectanglePoint = cv::Point(rescaledPoint.x + (selectedPattern.cols * m_scaleFactor), rescaledPoint.y + (selectedPattern.rows * m_scaleFactor));
//        cv::Rect rect = cv::Rect(rescaledPoint.x, rescaledPoint.y,  rescaledPoint.x + 50, rescaledPoint.y + 50);//rectanglePoint.x, rectanglePoint.y);

        cv::Rect roiRect(rescaledPoint.x, rescaledPoint.y, m_resizedPosterImage.size().width, m_resizedPosterImage.size().height);
        printf("I SHOULD BE PRINTING IMAGE\n");
        cv::Mat roi(outputImage, roiRect);
        m_resizedPosterImage.copyTo(outputImage(roiRect));
//        cv::rectangle(outputImage, rescaledPoint, point, CV_RGB(0, 0, 0), 3);
        
//        cv::resize(m_resizedPosterImage, outputImage, cv::Size(rect.width, rect.height));
    }
    
    // Save to member variable
    outputImage.copyTo(m_sampleImage);
}

void PatternDetector::findPattern(cv::Mat queryImageGray, cv::Mat scaledPattern)
{
    cv::Mat queryImageGrayScale;
    
    // (2) Scale down the image
    float h = queryImageGray.rows / m_scaleFactor;
    float w = queryImageGray.cols / m_scaleFactor;
    cv::resize(queryImageGray, queryImageGrayScale, cv::Size(w,h));
    
    // (3) Perform the matching
    int rows = queryImageGrayScale.rows - scaledPattern.rows + 1;
    int cols = queryImageGrayScale.cols - scaledPattern.cols + 1;
    cv::Mat resultImage = cv::Mat(cols, rows, CV_32FC1);
    cv::matchTemplate(queryImageGrayScale, scaledPattern, resultImage, m_matchMethod);
    
    // (4) Find the min/max settings
    double minVal, maxVal;
    cv::Point minLoc, maxLoc;
    cv::minMaxLoc(resultImage, &minVal, &maxVal, &minLoc, &maxLoc, cv::Mat());
    switch ( m_matchMethod ) {
        case CV_TM_SQDIFF:
        case CV_TM_SQDIFF_NORMED:
            m_matchPoint = minLoc;
            m_matchValue = minVal;
            break;
        default:
            m_matchPoint = maxLoc;
            m_matchValue = maxVal;
            break;
    }
}

const cv::Point& PatternDetector::matchPoint()
{
    return m_matchPoint;
}

float PatternDetector::matchValue()
{
    return m_matchValue;
}

float PatternDetector::matchThresholdValue()
{
    return m_matchThresholdValue;
}

bool PatternDetector::isTracking()
{
    switch ( m_matchMethod ) {
        case CV_TM_SQDIFF:
        case CV_TM_SQDIFF_NORMED:
            return m_matchValue < m_matchThresholdValue;
        default:
            return m_matchValue > m_matchThresholdValue;
    }
}

const cv::Mat& PatternDetector::sampleImage()
{
    return m_sampleImage;
}