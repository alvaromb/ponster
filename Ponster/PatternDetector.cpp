//
//  PatternDetector.cpp
//  Ponster
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#include "PatternDetector.h"

const float kDefaultScaleFactor     = 1.00f; //2.00f;
//const float k50ScaleFactor          = 4.00f;
//const float kDefaultThresholdValue  = 0.70f;

PatternDetector::PatternDetector(const cv::Mat& patternImage, const cv::Mat& posterImage)
{
    m_scaleFactor = kDefaultScaleFactor;
    
    // (1) Save the pattern image
    m_patternImage = patternImage;
    
    // (2) Create a resized grayscale version of the pattern image
    cv::resize(posterImage, m_resizedPosterImage, cv::Size(posterImage.cols/m_scaleFactor, posterImage.rows/m_scaleFactor));
    printf("\n m_resizedPosterImage.size = (%d, %d) \n\n", m_resizedPosterImage.rows, m_resizedPosterImage.cols);
    cv::Mat patternImageGray;
    switch (patternImage.channels())
    {
        case 4: /* 3 color channels + 1 alpha */
            cv::cvtColor(m_patternImage, patternImageGray, CV_RGBA2GRAY);
            break;
        case 3: /* 3 color channels */
            cv::cvtColor(m_patternImage, patternImageGray, CV_RGB2GRAY);
            break;
        case 1: /* 1 color channel, grayscale */
            patternImageGray = m_patternImage;
            break;
    }
    
    // Make binary image
    threshold(patternImageGray, m_patternImageGrayScaled, 125, 255, CV_THRESH_BINARY_INV);
    
    // SURF
//    double t = (double)getTickCount();
//    m_detector = SurfFeatureDetector(4);
//    m_detector.detect(m_patternImageGrayScaled, m_posterKeypoints);
//    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "surf keypoints [s]: " << t/1.0 << std::endl;
    
    // SURF descriptors
//    m_extractor = cv::SurfDescriptorExtractor();
//    m_extractor.compute(m_patternImageGrayScaled, m_posterKeypoints, m_posterDescriptors);
//    cout << "surf descriptors [d]: " << m_posterDescriptors.size() << endl;
    
//    // (5) Detect keypoints using ORB
    double t = (double)getTickCount();
    m_detector = OrbFeatureDetector();
    m_detector.detect(m_patternImageGrayScaled, m_posterKeypoints);
    t = ((double)getTickCount() - t)/getTickFrequency();
    std::cout << "orb keypoints [s]: " << t/1.0 << std::endl;

    
//    double t = (double)getTickCount();
//    m_surf_gpu = SURF_GPU(minHessian);
//    GpuMat gpuPattern;
//    gpuPattern.upload(m_patternImageGrayScaled);
//    m_surf_gpu.downloadKeypoints(gpuPattern, m_posterKeypoints);
//    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "surf gpu keypoints [s]: " << t/1.0 << std::endl;
    
    
    
    
//    m_detector = OrbFeatureDetector();
//    m_detector.detect(m_patternImageGrayScaled, m_posterKeypoints);
    
    
    
    m_extractor = OrbDescriptorExtractor();
    m_extractor.compute(m_patternImageGrayScaled, m_posterKeypoints, m_posterDescriptors);
//    if (m_posterDescriptors.type() != CV_32F) {
//        m_posterDescriptors.convertTo(m_posterDescriptors, CV_32F);
//    }

//    m_freak = FREAK(true, true, 22, 4, vector<int>());
//    FREAK freak(true, true, 22, 4, vector<int>());
//    m_freak_extractor = freak;
//    freak.compute(m_patternImageGrayScaled, m_posterKeypoints, m_posterDescriptors);
    
    if (m_posterDescriptors.empty()) {
        printf("WARNING empty descriptors \n");
    }
    
    // (7) Initialize matcher
//    m_matcher = FlannBasedMatcher(new flann::LshIndexParams(6, 12, 1), new cv::flann::SearchParams(50));
    m_matcher = FlannBasedMatcher(new flann::LshIndexParams(30, 12, 2), new cv::flann::SearchParams(50));
//    FlannBasedMatcher m_matcher(new flann::LshIndexParams(30, 12, 2), new cv::flann::SearchParams(50));
//    vector<Mat> vDescriptors;
//    vDescriptors.push_back(m_posterDescriptors);
//    m_matcher.add(vDescriptors);
//    m_matcher.train();
//    m_bfmatcher = BFMatcher(NORM_HAMMING, true);
    
//    FlannBasedMatcher macher = new FlannBasedMatcher(new flann::LshIndexParams(6, 12, 1), new cv::flann::SearchParams(50));
//    cv::drawKeypoints(m_patternImageGrayScaled, m_posterKeypoints, m_sampleImage);
    
//    m_matcher = FlannBasedMatcher();
}

void PatternDetector::scanFrame(VideoFrame frame)
{
    Mat outputImage = PatternDetector::fastDetection(frame);
    outputImage.copyTo(m_sampleImage);
    
//    float selectedScaleFactor = m_scaleFactor;
//    selectedPattern = m_patternImageGrayScaled;
//    PatternDetector::findPattern(queryImageGray, selectedPattern);
//    if (!PatternDetector::isTracking()) {
//        selectedScaleFactor = k50ScaleFactor;
//        selectedPattern = m_patternImageGrayScaled50;
//        PatternDetector::findPattern(queryImageGray, selectedPattern);
//    }
//    
//    if (PatternDetector::isTracking()) {
//        // Compute the rescaled origin of the detection
//        cv::Point rescaledPoint = m_matchPoint * m_scaleFactor;
//        
//        // Overlay poster image depending on the size
//        cv::Rect roiRect;
//        if (selectedScaleFactor == m_scaleFactor) {
//            roiRect = cv::Rect(rescaledPoint.x, rescaledPoint.y, m_resizedPosterImage.size().width, m_resizedPosterImage.size().height);
//        }
//        else if (selectedScaleFactor == k50ScaleFactor) {
//            roiRect = cv::Rect(rescaledPoint.x, rescaledPoint.y, m_resized50PosterImage.size().width, m_resized50PosterImage.size().height);
//        }
//        
////        printf("\n roiRect     (%d, %d, %d, %d)", roiRect.x, roiRect.y, roiRect.width, roiRect.height);
////        printf("\n outputImage (%d, %d) \n", outputImage.cols, outputImage.rows);
//        
//        // Check if the roi is inside the bounds of the outputImage
//        if (((roiRect.y + roiRect.height) <= outputImage.rows) && ((roiRect.x + roiRect.width) <= outputImage.cols)) {
//            cv::Mat roi(outputImage, roiRect);
//#warning TODO fix this
//            if (selectedScaleFactor == m_scaleFactor) {
//                m_resizedPosterImage.copyTo(outputImage(roiRect));
//            }
//            else {
//                m_resized50PosterImage.copyTo(outputImage(roiRect));
//            }
//            
//        }
//    }
//    
//    // Save to member variable
//    outputImage.copyTo(m_sampleImage);
}


Mat PatternDetector::fastDetection(VideoFrame frame)
{
    // (1) Build the grayscale query image from the camera data
    double total = 0;
    double t = (double)getTickCount();
    cv::Mat queryImageGray, queryImageGrayResized, outputImage;
    cv::Mat queryImage = cv::Mat(frame.width, frame.height, CV_8UC4, frame.data, frame.bytesPerRow);
    cv::cvtColor(queryImage, queryImageGray, CV_RGBA2GRAY);//CV_BGR2GRAY);
//    float h = queryImageGray.rows / m_scaleFactor;
//    float w = queryImageGray.cols / m_scaleFactor;
//    cv::resize(queryImageGray, queryImageGrayResized, cv::Size(w, h));

    // Generate binary image
    threshold(queryImageGray, queryImageGrayResized, 125, 255, CV_THRESH_BINARY_INV);
//    GaussianBlur( queryImageGrayResized, queryImageGrayResized, cv::Size(7, 7), 2, 2 );
    cv::cvtColor(queryImage, outputImage, CV_BGR2BGRA);
    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "query image building  [s]: " << t/1.0 << std::endl;
    total += t/1.0;
    
    // (2) Detect scene keypoints
    t = (double)getTickCount();
    vector<KeyPoint> sceneKeypoints;
//    m_surf_detector.detect(queryImageGrayResized, sceneKeypoints);
    m_detector.detect(queryImageGrayResized, sceneKeypoints);
    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "detection time        [s]: " << t/1.0 << std::endl;
    total += t/1.0;
    
    if (sceneKeypoints.size() <= 1) {
        return outputImage;
    }
    
    // (3) Calculate scene descriptors
    t = (double)getTickCount();
    Mat sceneDescriptors;
    FREAK freak(true, true, 22, 4, vector<int>());
//    freak.compute(queryImageGrayResized, sceneKeypoints, sceneDescriptors);
//    m_detector.compute(queryImageGrayResized, sceneKeypoints, sceneDescriptors);
    m_extractor.compute(queryImageGrayResized, sceneKeypoints, sceneDescriptors);
    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "extraction time       [s]: " << t/1.0 << std::endl;
    total += t/1.0;
//    if (sceneDescriptors.type() != CV_32F) {
//        sceneDescriptors.convertTo(sceneDescriptors, CV_32F);
//    }
    if (sceneDescriptors.empty()) {
//        printf("WARNING empty scene descriptors \n");
        return outputImage;
    }
    
    // (4) Match descriptors
    t = (double)getTickCount();
    vector<DMatch> matches;
    m_matcher.match(m_posterDescriptors, sceneDescriptors, matches);
//    m_bfmatcher.match(m_posterDescriptors, sceneDescriptors, matches);
//    printf("matches size %lu \n", matches.size());
    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "matching time         [s]: " << t/1.0 << std::endl;
    total += t/1.0;

    // (5) Compute good matches
    t = (double)getTickCount();
    double max_dist = 0; double min_dist = 100;
    for (int i = 0; i < m_posterDescriptors.rows; i++) {
        double dist = matches[i].distance;
        if (dist < min_dist) min_dist = dist;
        if (dist > max_dist) max_dist = dist;
    }
//    printf("-- Max dist : %f \n", max_dist );
//    printf("-- Min dist : %f \n", min_dist );
    
    // Draw only "good" matches (i.e. whose distance is less than 3*min_dist )
    vector<cv::DMatch> good_matches;
    for (int i = 0; i < m_posterDescriptors.rows; i++) {
        if (matches[i].distance < 2*min_dist) { //3*min_dist
            good_matches.push_back(matches[i]);
        }
    }
//    printf("-- Matches = %lu \n", matches.size());
//    printf("Good matches            = %lu \n", good_matches.size());
    if (good_matches.size() < 4) {
//        cout << "-- NO GOOD MATCHES" << endl;
        return outputImage;
    }
    
    // Localize the object
    vector<cv::Point2f> obj;
    vector<cv::Point2f> scene;
    
    for (int i = 0; i < good_matches.size(); i++) {
        // Get the keypoints from the good matches
        obj.push_back(m_posterKeypoints[good_matches[i].queryIdx].pt);
        scene.push_back(sceneKeypoints[good_matches[i].trainIdx].pt);
    }
    
    /**
     * ERROR: OpenCV Error: Assertion failed (count >= 4) in cvFindHomography
     * http://stackoverflow.com/questions/14430184/opencv-cv-findhomography-assertion-error-counter-4
     */
    if (obj.size() < 4) {
        return outputImage;
    }
    Mat H = findHomography(obj, scene, CV_RANSAC);
    
    t = ((double)getTickCount() - t)/getTickFrequency();
//    std::cout << "good matches and homography time [s]: " << t/1.0 << std::endl;
    total += t/1.0;
    
    // Get the corners from the image_1 ( the object to be "detected" )
    std::vector<cv::Point2f> obj_corners(4);
    obj_corners[0] = cvPoint(0, 0);
    obj_corners[1] = cvPoint(m_patternImageGrayScaled.cols, 0);
    obj_corners[2] = cvPoint(m_patternImageGrayScaled.cols, m_patternImageGrayScaled.rows);
    obj_corners[3] = cvPoint(0, m_patternImageGrayScaled.rows);
    std::vector<cv::Point2f> scene_corners(4);
    
    perspectiveTransform(obj_corners, scene_corners, H);
    
    // Draw lines between the corners (the mapped object in the scene - image_2 )
    line(outputImage, scene_corners[0], scene_corners[1], cv::Scalar(0, 255, 0), 4);
    line(outputImage, scene_corners[1], scene_corners[2], cv::Scalar(0, 255, 0), 4);
    line(outputImage, scene_corners[2], scene_corners[3], cv::Scalar(0, 255, 0), 4);
    line(outputImage, scene_corners[3], scene_corners[0], cv::Scalar(0, 255, 0), 4);
    // r g y b
    circle(outputImage, scene_corners[0], 15, Scalar(255, 0, 0));   // r
    circle(outputImage, scene_corners[1], 15, Scalar(0, 255, 0));   // g
    circle(outputImage, scene_corners[2], 15, Scalar(0, 0, 255));   // b
    circle(outputImage, scene_corners[3], 15, Scalar(255, 255, 0)); // y
    
    std::cout << "total frame time      [s]: " << total << std::endl;
//    std::cout << "---------------------------" << std::endl;
    
    return outputImage;
}

/**
 * Taken from OpenCV docs: 
 * http://docs.opencv.org/doc/tutorials/features2d/feature_homography/feature_homography.html
 * and:
 * http://frankbergschneider.weebly.com
 */
cv::Mat PatternDetector::surfPattern(VideoFrame frame)
{
    // (1) Build the grayscale query image from the camera data
    cv::Mat queryImageGray, queryImageGrayResized, outputImage;
    cv::Mat queryImage = cv::Mat(frame.width, frame.height, CV_8UC4, frame.data, frame.bytesPerRow);//cv::Mat(frame.height, frame.width, CV_8UC4, frame.data, frame.bytesPerRow);
    cv::cvtColor(queryImage, queryImageGray, CV_BGR2GRAY);
    float h = queryImageGray.rows / m_scaleFactor;
    float w = queryImageGray.cols / m_scaleFactor;
    cv::resize(queryImageGray, queryImageGrayResized, cv::Size(w, h));
    cv::cvtColor(queryImage, outputImage, CV_BGR2BGRA);
    
    // (2) Detect scene keypoints using SURF
    std::vector<cv::KeyPoint> sceneKeypoints;
    m_detector.detect(queryImageGrayResized, sceneKeypoints);
    if (sceneKeypoints.size() == 0) {
        return outputImage;
    }
    
    // (3) Calculate scene descriptors
    cv::Mat sceneDescriptors;
//    m_extractor.compute(queryImageGrayResized, sceneKeypoints, sceneDescriptors);
    
    // (4) Match descriptors using FLANN
    std::vector<cv::DMatch> matches;
    m_matcher.match(m_posterDescriptors, sceneDescriptors, matches);
    
    // (5) Compute good matches
    double max_dist = 0; double min_dist = 100;
    for (int i = 0; i < m_posterDescriptors.rows; i++) {
        double dist = matches[i].distance;
        if (dist < min_dist) min_dist = dist;
        if (dist > max_dist) max_dist = dist;
    }
    printf("-- Max dist : %f \n", max_dist );
    printf("-- Min dist : %f \n", min_dist );
    
    //-- Draw only "good" matches (i.e. whose distance is less than 3*min_dist )
    std::vector<cv::DMatch> good_matches;
    for (int i = 0; i < m_posterDescriptors.rows; i++) {
        if (matches[i].distance < 3*min_dist) {
            good_matches.push_back(matches[i]);
        }
    }
    printf("-- Good matches = %lu \n", good_matches.size());
    
    //-- Localize the object
    std::vector<cv::Point2f> obj;
    std::vector<cv::Point2f> scene;
    
    for (int i = 0; i < good_matches.size(); i++) {
        //-- Get the keypoints from the good matches
        obj.push_back(m_posterKeypoints[good_matches[i].queryIdx].pt);
        scene.push_back(sceneKeypoints[good_matches[i].trainIdx].pt);
    }
    
    /**
     * ERROR: OpenCV Error: Assertion failed (count >= 4) in cvFindHomography
     * http://stackoverflow.com/questions/14430184/opencv-cv-findhomography-assertion-error-counter-4
     */
    cv::Mat H = findHomography(obj, scene, CV_RANSAC);
    
    //-- Get the corners from the image_1 ( the object to be "detected" )
    std::vector<cv::Point2f> obj_corners(4);
    obj_corners[0] = cvPoint(0, 0);
    obj_corners[1] = cvPoint(m_patternImageGrayScaled.cols, 0);
    obj_corners[2] = cvPoint(m_patternImageGrayScaled.cols, m_patternImageGrayScaled.rows);
    obj_corners[3] = cvPoint(0, m_patternImageGrayScaled.rows);
    std::vector<cv::Point2f> scene_corners(4);
    
    perspectiveTransform(obj_corners, scene_corners, H);
    
    //-- Draw lines between the corners (the mapped object in the scene - image_2 )
    line(outputImage, scene_corners[0], scene_corners[1], cv::Scalar(0, 255, 0), 4);
    line(outputImage, scene_corners[1], scene_corners[2], cv::Scalar(0, 255, 0), 4);
    line(outputImage, scene_corners[2], scene_corners[3], cv::Scalar(0, 255, 0), 4);
    line(outputImage, scene_corners[3], scene_corners[0], cv::Scalar(0, 255, 0), 4);
    // r g y b
    circle(outputImage, scene_corners[0], 15, Scalar(255, 0, 0));   // r
    circle(outputImage, scene_corners[1], 15, Scalar(0, 255, 0));   // g
    circle(outputImage, scene_corners[2], 15, Scalar(0, 0, 255));   // b
    circle(outputImage, scene_corners[3], 15, Scalar(255, 255, 0)); // y

    return outputImage;
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
