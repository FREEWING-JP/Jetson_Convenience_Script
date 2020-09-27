#ifndef CAFFE_COMMON_CV4_HPP_
#define CAFFE_COMMON_CV4_HPP_

// Supporting OpenCV4
// #define CV_MAJOR_VERSION CV_VERSION_MAJOR

// #if (CV_MAJOR_VERSION == 4)
// src\caffe\layers\video_data_layer.cpp
// src\caffe\layers\window_data_layer.cpp
// src\caffe\test\test_io.cpp
// src\caffe\util\bbox_util.cpp
// src\caffe\util\im_transforms.cpp
// src\caffe\util\io.cpp
#include <opencv2/imgcodecs/imgcodecs.hpp>

#define CV_GRAY2BGR  cv::COLOR_GRAY2BGR
#define CV_BGR2GRAY  cv::COLOR_BGR2GRAY
#define CV_BGR2YCrCb cv::COLOR_BGR2YCrCb
#define CV_YCrCb2BGR cv::COLOR_YCrCb2BGR
#define CV_IMWRITE_JPEG_QUALITY cv::IMWRITE_JPEG_QUALITY
#define CV_THRESH_BINARY_INV    cv::THRESH_BINARY_INV
#define CV_THRESH_OTSU          cv::THRESH_OTSU

#define CV_BGR2HSV cv::COLOR_BGR2HSV
#define CV_HSV2BGR cv::COLOR_HSV2BGR
#define CV_BGR2Lab cv::COLOR_BGR2Lab

#define CV_GRAY2RGB     cv::COLOR_GRAY2RGB
#define CV_INTER_LINEAR cv::INTER_LINEAR

#define CV_LOAD_IMAGE_COLOR     cv::IMREAD_COLOR
#define CV_LOAD_IMAGE_GRAYSCALE cv::IMREAD_GRAYSCALE

// CV_RGB=RGB
// cv::Scalar=BGR
#define CV_RGB(r, g, b)  cv::Scalar((b), (g), (r), 0)
#ifndef CV_FILLED
// warning: "CV_FILLED" redefined
// /usr/include/opencv4/opencv2/imgproc/imgproc_c.h:952:0
// note: this is the location of the previous definition
// #define CV_FILLED -1
#define CV_FILLED cv::FILLED
#endif
#define CV_FOURCC cv::VideoWriter::fourcc

#include <opencv2/videoio.hpp>

#define CV_CAP_PROP_FRAME_COUNT CAP_PROP_FRAME_COUNT
#define CV_CAP_PROP_POS_FRAMES  CAP_PROP_POS_FRAMES
// #endif

#endif  // CAFFE_COMMON_CV4_HPP_
