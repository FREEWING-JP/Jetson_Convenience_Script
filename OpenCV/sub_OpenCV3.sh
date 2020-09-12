#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


OPENCV_VERSION=3.4.10
if [ "$1" != "" ]; then
  OPENCV_VERSION="$1"
fi


# ===
# ===
echo "OpenCV $OPENCV_VERSION"


# Check OpenCV version
# 4.1.1 = JetPack 4.3/4.4
opencv_version | grep "4.1.1"
if [ $? = 0 ]; then
  # OpenCV 4.1.1
  # uninstall OpenCV
  sudo apt -y purge libopencv libopencv-dev libopencv-python
  sudo sudo apt purge -y libopencv*
  sudo apt -y autoremove
fi


# ===
# NG Install libturbojpeg
# sudo apt-get -y install libturbojpeg libturbojpeg-dev
# Note, selecting 'libturbojpeg0-dev' instead of 'libturbojpeg-dev'
# sudo apt-get -y install libturbojpeg libturbojpeg0-dev
# ls -l /usr/lib/aarch64-linux-gnu/libturbojpeg.so
# sudo ln -s /usr/lib/aarch64-linux-gnu/libturbojpeg.so.0.1.0 /usr/lib/aarch64-linux-gnu/libturbojpeg.so
# sudo ldconfig

# OK Install libjpeg-turbo
# libjpeg-turbo = libjpeg.so
sudo apt install libjpeg-turbo8 libjpeg-turbo8-dev


# ===
# Required Packages
# [compiler]
sudo apt-get install -y build-essential

# [required]
# libgtk2.0-dev GTK+ 2.x or Carbon support function cvShowImage
sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

# [optional]
# libjasper-dev E: Unable to locate package libjasper-dev
# no need libdc1394-22-dev
sudo apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev

# fatal error: sys/videoio.h : No such file or directory
sudo apt-get install -y libv4l-dev

# Install libopenblas-base libopenblas-dev
sudo apt-get -y install libopenblas-base libopenblas-dev

#   -D BUILD_opencv_python2=ON
# sudo apt-get install python2.7-dev

# --   Python 3:
# --     Libraries:  NO
# --     Libraries:  /usr/lib/aarch64-linux-gnu/libpython3.6m.so (ver 3.6.9)
#   -D BUILD_opencv_python3=ON
# sudo apt-get install python3.6-dev
sudo apt-get -y install python3-dev



# ===
cd
mkdir opencv_34
cd opencv_34
# OpenCV3 OpenCV 3.4.10 4 Apr 2020 3.4.10 1cc1e6f
git clone https://github.com/opencv/opencv.git -b $OPENCV_VERSION --depth 1

# no need opencv_contrib
# git clone https://github.com/opencv/opencv_contrib.git -b $OPENCV_VERSION --depth 1


# ===
cd opencv

mkdir build
cd build

# ===
# OpenCV highgui module -D BUILD_opencv_highgui=ON
# OpenCV NVIDIA GPU CUDA -D WITH_CUDA=ON
# OpenCV ARM NEON Advanced SIMD -D ENABLE_NEON=ON
# CUDA cuBLAS -D CUDA_FAST_MATH=ON -D WITH_CUBLAS=ON
# GStreamer -D WITH_GSTREAMER=ON
# libv4l/libv4l2 -D WITH_LIBV4L=ON
# ===
# -D BUILD_EXAMPLES=OFF
# -D BUILD_TESTS=OFF
# -D BUILD_PERF_TESTS=OFF
# -D BUILD_DOCS=OFF

# ===
# No module named 'cv2'
# -D BUILD_opencv_python2=OFF
# -D BUILD_opencv_python3=ON
# -D PYTHON3_EXECUTABLE=$(which python3)
# -D PYTHON3_EXECUTABLE=python3
# echo $(which python3)
# /usr/bin/python3

# ===
# JPEG
#    -D BUILD_JPEG=OFF
#    -D WITH_JPEG=ON
# none
#    -D JPEG_INCLUDE_DIR=/usr/include/
# -- Found JPEG: /usr/lib/aarch64-linux-gnu/libjpeg.so (found version "80")
# --     JPEG:   /usr/lib/aarch64-linux-gnu/libjpeg.so (ver 80)

# libjpeg-turbo 1.5.2
#    -D JPEG_INCLUDE_DIR=/usr/include/
#    -D JPEG_LIBRARY=/usr/lib/aarch64-linux-gnu/libjpeg.so
# -- Found JPEG: /usr/lib/aarch64-linux-gnu/libjpeg.so (found version "80")
# --     JPEG:   /usr/lib/aarch64-linux-gnu/libjpeg.so (ver 80)

# libjpeg-turbo 2.0.5 ae87a95 Jun 24 2020
#    -D JPEG_INCLUDE_DIR=/opt/libjpeg-turbo/include
#    -D JPEG_LIBRARY=/opt/libjpeg-turbo/lib64/libturbojpeg.so
# -- Found JPEG: /opt/libjpeg-turbo/lib64/libturbojpeg.so (found version "62")
# --     JPEG:   /opt/libjpeg-turbo/lib64/libturbojpeg.so (ver 62)

# ===
JPEG_INCLUDE_DIR=/usr/include/
JPEG_LIBRARY=

if [ -e /usr/lib/aarch64-linux-gnu/libjpeg.so ]; then
  JPEG_INCLUDE_DIR=/usr/include/
  JPEG_LIBRARY=/usr/lib/aarch64-linux-gnu/libjpeg.so
fi

if [ -e /opt/libjpeg-turbo/lib64/libturbojpeg.so ]; then
  JPEG_INCLUDE_DIR=/opt/libjpeg-turbo/include
  JPEG_LIBRARY=/opt/libjpeg-turbo/lib64/libturbojpeg.so
fi

echo "JPEG_INCLUDE_DIR: $JPEG_INCLUDE_DIR"
echo "JPEG_LIBRARY: $JPEG_LIBRARY"

# ===
cmake \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  \
  -D BUILD_opencv_highgui=ON \
  \
  -D CUDA_FAST_MATH=ON \
  -D WITH_CUDA=ON \
  -D WITH_CUBLAS=ON \
  -D WITH_GSTREAMER=ON -D WITH_LIBV4L=ON \
  -D ENABLE_NEON=ON \
  -D ENABLE_FAST_MATH=OFF \
  \
  -D BUILD_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_DOCS=OFF \
  \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=ON \
  -D PYTHON3_EXECUTABLE=$(which python3) \
  \
  -D BUILD_JPEG=OFF \
  -D WITH_JPEG=ON \
  -D JPEG_INCLUDE_DIR=$JPEG_INCLUDE_DIR \
  -D JPEG_LIBRARY=$JPEG_LIBRARY \
  ..

# -- Configuring done
# -- Generating done
# -- Build files have been written to: /home/jetson/opencv_34/opencv/build


# ===
make clean
# time make -j4
time make -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit
fi


# ===
# jetson@jetson-desktop:~/opencv_34/opencv/build$ ./bin/opencv_version
./bin/opencv_version
# 3.4.x

# ===
# Install OpenCV 3.4.x
sudo make install

# ===
sudo ldconfig

# ===
opencv_version
# 3.4.x
if [ $? = 0 ]; then
  echo "=========="
  echo "=== OK ==="
  echo "=========="
else
  echo "=========="
  echo "=== NG ==="
  echo "=========="
fi

