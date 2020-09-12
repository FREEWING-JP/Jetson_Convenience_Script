#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/opencv_440 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# OpenCV 4.4.0
# NVIDIA cuDNN 8.0
# GStreamer

OPENCV_VERSION=4.4.0

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


opencv_version | grep "$OPENCV_VERSION"
if [ $? = 0 ]; then
  echo "Already Exists OpenCV $OPENCV_VERSION"
  exit 0
fi


# ===
# Install CMake
INSTALL_DEB=0
if [ -e ../../00_deb/OpenCV-4.4.0-aarch64-dev.deb ]; then

  echo "Found OpenCV .deb package file"
  echo "Build OpenCV need lot of time"

  read -p "Install from .deb package ? or Build ? (i/b):" inst
  case "$inst" in [iI]*) INSTALL_DEB=1 ;; [bB]*) ;; *) echo "Abort" ; exit 1 ;; esac
fi


# https://github.com/opencv/opencv/blob/master/doc/tutorials/introduction/linux_gcc_cmake/linux_gcc_cmake.markdown

# https://github.com/opencv/opencv/blob/master/doc/tutorials/introduction/linux_install/linux_install.markdown

# https://github.com/opencv/opencv/blob/master/doc/tutorials/introduction/building_tegra_cuda/building_tegra_cuda.markdown

sudo apt update



# Required Packages
# GCC 4.4.x or later
# CMake 2.8.7 or higher
# Git
# GTK+2.x or higher, including headers (libgtk2.0-dev)
sudo apt install -y pkg-config libgtk2.0-dev
sudo apt install -y build-essential git nano

# Python 2.6 or later and Numpy 1.5 or later with developer packages (python-dev, python-numpy)
# ffmpeg or libav development packages
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev

# [optional]
sudo apt install -y libtbb2 libtbb-dev

# [optional] libdc1394 2.x
# [optional]
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev
# libjasper-dev

# libdc1394-22-dev

# [optional] CUDA Toolkit 6.5 or higher



# Prerequisites for Ubuntu Linux
sudo apt install -y \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libeigen3-dev \
    libglew-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    libpostproc-dev \
    libswscale-dev \
    libtbb-dev \
    libtiff5-dev \
    zlib1g-dev \
    pkg-config

# Package libpng12-dev is not available
#     libpng12-dev

# E: Unable to locate package libjasper-dev
#     libjasper-dev

# If you want the Python bindings to be built
sudo apt install -y python3-dev python3-numpy

# GStreamer
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# V4L Video4Linux V4L2
sudo apt install -y libv4l-dev libv4l2rds0 qv4l2 v4l-utils v4l2ucp

# set(_required_ffmpeg_libraries libavcodec libavformat libavutil libswscale)


# ===
if [ $INSTALL_DEB -ne 0 ]; then
  sudo dpkg -i ../../00_deb/OpenCV-4.4.0-aarch64-dev.deb
  sudo dpkg -i ../../00_deb/OpenCV-4.4.0-aarch64-libs.deb
  sudo dpkg -i ../../00_deb/OpenCV-4.4.0-aarch64-licenses.deb
  sudo dpkg -i ../../00_deb/OpenCV-4.4.0-aarch64-main.deb
  sudo dpkg -i ../../00_deb/OpenCV-4.4.0-aarch64-python.deb
  sudo dpkg -i ../../00_deb/OpenCV-4.4.0-aarch64-scripts.deb
  opencv_version
  exit 0
fi


# ===
cd
mkdir opencv_440
cd opencv_440
git clone https://github.com/opencv/opencv_contrib -b $OPENCV_VERSION --depth 1
git clone https://github.com/opencv/opencv -b $OPENCV_VERSION --depth 1 opencv
cd opencv

mkdir build
cd build

# CMake Error at modules/core/CMakeLists.txt:40 (message):
#   CUDA: OpenCV requires enabled 'cudev' module from 'opencv_contrib'
#   repository: https://github.com/opencv/opencv_contrib

# Jetson Products GPU Compute Capability
# https://developer.nvidia.com/cuda-gpus

# Jetson Nano
# -D CUDA_ARCH_BIN=5.3 -D CUDA_ARCH_PTX=5.3

# Jetson Xavier NX
# -D CUDA_ARCH_BIN=7.2 -D CUDA_ARCH_PTX=7.2

tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

CUDA_DEF=""

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  CUDA_DEF="7.2"
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  CUDA_DEF="5.3"
fi

# Jetson Nano and Xavier NX
CUDA_DEF="5.3 7.2"
echo $CUDA_DEF

# NVIDIA PTX architectures Parallel Thread Execution
# -D CUDA_ARCH_PTX=""

cmake \
  -D CMAKE_BUILD_TYPE=Release \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  \
  -D CUDNN_VERSION='8.0' \
  -D CUDA_ARCH_BIN="${CUDA_DEF}" \
  -D CUDA_ARCH_PTX="" \
  -D WITH_CUDA=ON -D WITH_CUBLAS=ON -D WITH_CUDNN=ON \
  -D WITH_CUFFT=ON \
  -D CUDA_FAST_MATH=ON \
  -D OPENCV_DNN_CUDA=ON \
  -D ENABLE_FAST_MATH=OFF \
  \
  -D WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF \
  -D WITH_LIBV4L=ON \
  \
  -D BUILD_opencv_highgui=ON \
  \
  -D WITH_EIGEN=ON \
  -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
  \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=ON \
  \
  -D WITH_TBB=OFF \
  -D WITH_1394=OFF \
  \
  -D BUILD_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_DOCS=OFF \
  \
  -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
  ..

# --   NVIDIA CUDA:                   YES (ver 10.2, CUFFT CUBLAS FAST_MATH)
# --     NVIDIA GPU arch:             53 72
# --     NVIDIA PTX archs:
# --
# --   cuDNN:                         YES (ver 8.0)

time make -j$(nproc)

# Xavier NX time make -j4
# real    75m27.445s
# user    244m19.348s
# sys     9m48.136s

# Xavier NX time make -j6
# real    71m33.144s
# user    309m8.928s
# sys     12m1.020s


# ===
# OpenCV version
./bin/opencv_version
# 4.4.0

sudo make install


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

