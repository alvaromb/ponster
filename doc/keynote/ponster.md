footer: Álvaro Medina Ballester, PFC EI, UIB, 2014

# Augmented reality on mobile devices
### A comparison of technologies to build augmented reality apps under iOS platform

---

# [fit] What is augmented reality?

---

> Mix real world data with virtual elements.
-- Myself

---

![original](DAQRI-LEGO-6.jpg)

---

![fit](skyguide.png)

---

# Augmented reality on mobile devices

- Different ways to bring it to mobile

- Faster, more robust CV algorithms introduced recently

- Powerful mobile devices

---

# A8 chip performance

![inline](a8performance.png)

- Source: Apple, Geekbench performance test

---

# Different ways to bring AR

- Image processing-only
- Location sensors
- Combination

---

## First hypothesis
### Use video feed from the camera to process each frame with computer-vision algorithms

---

# Key concepts

- **Robustness**: quality of the tracking algorithm when the scene changes and the object to track is hard to determine.
- **Invariance**: capacity of algorithms to be tolerant to rotation, scale and perspective changes.
- **Performance**:
    - 20 FPS minimum acceptable
    - 30 FPS enough

---

# Image processing-only approximation
## Template matching & feature detection

---

## Template matching
### Find areas of an image that are similar to the _template image_ provided

---

## Template matching

![](templatematching.jpg)

---

![](templatematching.jpg)

## Template matching

Several methods of template matching: `CCOR`, `SQDIFF`


25~30 FPS on A6 & A8 chip


Not invariant to rotation, scale, perspective warp


Easy to implement

---

## Template matching pseudocode

```c++
// Perform Match Template
cv::matchTemplate(videoFrame, pattern, resultImage, matchMethod);

// If pattern has been found, draw poster
if (PatternDetector::isTracking()) {
  roiRect = cv::Rect(x, y, poster.size().width, poster.size().height);
  poster.copyTo(outputImage(roiRect));
}

// Copy the output image
poster.copyTo(outputImage);
```
