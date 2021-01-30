#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/nvcaffe ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# OpenCV version
OPENCV_VERSION=`opencv_version`
if [ $? != 0 ]; then
  echo "OpenCV not Found"
  echo "Need OpenCV v4.x"
  exit 0
fi

echo $OPENCV_VERSION
if [[ ${OPENCV_VERSION} =~ ^([0-9]+)\..*$ ]]; then
  echo ${BASH_REMATCH[1]}
  case "${BASH_REMATCH[1]}" in
      "4")
        echo "OpenCV v4.x"
        OPENCV_VERSION=4
        ;;
      *)
        echo "Need OpenCV v4.x"
        exit 1
        ;;
  esac

fi


if [ $OPENCV_VERSION = 4 ]; then
  echo "Caffe OpenCV 4.x patch"

  # ===
  # for Python 3
  # AttributeError: module 'caffe' has no attribute '__version__'
  sudo apt-get -y install pkg-config
  sudo apt-get -y install python3-dev python3-numpy python3-pip

  # ===
  # Caffe dependencies
  echo "Caffe dependencies"
  sudo apt-get -y install libprotobuf-dev libleveldb-dev liblmdb-dev
  # sudo apt-get -y install libsnappy-dev libopencv-dev
  sudo apt-get -y install libhdf5-serial-dev
  # sudo apt-get -y install protobuf-compiler
  # sudo apt-get -y install --no-install-recommends libboost-all-dev
  # sudo apt-get -y install libatlas-base-dev libopenblas-dev
  # ModuleNotFoundError: No module named 'skimage'
  sudo apt-get -y install python3-skimage
  # sudo pip3 install pydot
  # sudo apt-get -y install graphviz

  # ===
  # Makefile
  # PYTHON_LIBRARIES ?= boost_python python3.6
  # jetson@linux:~ $ python3 -V
  # Python 3.6.9
  pkg-config --libs opencv4
  dpkg -L libhdf5-dev

fi


# ===
# ===
# NVIDIA/caffe Git clone
cd
# clone NVCaffe
# NVCaffe Jan 9, 2021 caffe-0.17.4 21fae69
# Bug fix release: cuDNN v8, CUDA 11.1, Ubuntu 20.04 etc.
git clone https://github.com/NVIDIA/caffe nvcaffe --depth 1 -b v0.17.4
cd nvcaffe


# ===
# Install Dependencies
# Makefile.config
sudo apt-get -y install protobuf-compiler libprotoc-dev libboost-dev libgflags-dev libgoogle-glog-dev libhdf5-dev libleveldb-dev liblmdb-dev libopencv-dev libsnappy-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev libboost-python-dev python-skimage python-protobuf python-numpy python-pil

# libboost-regex-dev
sudo apt-get -y install libboost-regex-dev


# ===
# Copy Makefile.config
cp Makefile.config.example Makefile.config


# ===
# cuDNN
sed -i 's/^# USE_CUDNN/USE_CUDNN/' Makefile.config


# ===
# OpenCV 4.x
sed -i 's/^# USE_OPENCV := .*/USE_OPENCV := 1/' Makefile.config
sed -i 's/^# OPENCV_VERSION := .*/OPENCV_VERSION := 4/' Makefile.config


# ===
# OpenBlas
sed -i 's/^BLAS :=.*/BLAS := open/' Makefile.config


# ===
# BLAS
grep "^BLAS := open" Makefile.config
if [ $? = 0 ]; then
  # OpenBLAS, BLAS := open
  libopenblas=0
  if [ "$BLAS_INCLUDE" = "" ]; then
    echo $LD_LIBRARY_PATH | grep "OpenBLAS"
    if [ $? -ne  0 ]; then
      libopenblas=1
    fi
  fi
  if [ $libopenblas -eq 1 ]; then
    echo "install libopenblas-base libopenblas-dev"
    sudo apt-get -y install libopenblas-base libopenblas-dev
  else
    echo "remove libopenblas-base libopenblas-dev"
    sudo apt-get -y remove libopenblas-base libopenblas-dev

    # BLAS_INCLUDE := /opt/OpenBLAS/include
    # BLAS_LIB := /opt/OpenBLAS/lib
    sed -i 's/^# BLAS_INCLUDE :=/BLAS_INCLUDE :=/' Makefile.config
    sed -i 's/^BLAS_INCLUDE :=.*/BLAS_INCLUDE := \/opt\/OpenBLAS\/include/' Makefile.config
    sed -i 's/^# BLAS_LIB :=/BLAS_LIB :=/' Makefile.config
    sed -i 's/^BLAS_LIB :=.*/BLAS_LIB := \/opt\/OpenBLAS\/lib/' Makefile.config
  fi
else
  # ATLAS, BLAS := atlas
  sudo apt-get install libatlas-base-dev
fi


# ===
# CUDA_ARCH
tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  # Jetson Xavier NX sm_72
  # CUDA_ARCH := -gencode arch=compute_72,code=sm_72 \
  #                -gencode arch=compute_72,code=compute_72
  sed -i 's/arch=compute_50,code=sm_50/arch=compute_72,code=sm_72/' Makefile.config
  sed -i 's/arch=compute_52,code=sm_52 \\/arch=compute_72,code=compute_72/' Makefile.config
  sed -i '/arch=compute_60,code=sm_60 \\/d' Makefile.config
  sed -i '/arch=compute_61,code=sm_61 \\/d' Makefile.config
  sed -i '/arch=compute_70,code=sm_70 \\/d' Makefile.config
  sed -i '/arch=compute_75,code=sm_75 \\/d' Makefile.config
  sed -i '/arch=compute_75,code=compute_75/d' Makefile.config
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  # Jetson Nano sm_53
  sed -i 's/arch=compute_50,code=sm_50/arch=compute_53,code=sm_53/' Makefile.config
  sed -i 's/arch=compute_50,code=sm_52 \\/arch=compute_53,code=compute_53/' Makefile.config
  sed -i '/arch=compute_60,code=sm_60 \\/d' Makefile.config
  sed -i '/arch=compute_61,code=sm_61 \\/d' Makefile.config
  sed -i '/arch=compute_70,code=sm_70 \\/d' Makefile.config
  sed -i '/arch=compute_75,code=sm_75 \\/d' Makefile.config
  sed -i '/arch=compute_75,code=compute_75/d' Makefile.config
fi

# ===
# Python 3.6.9
# Uncomment to use Python 3 (default is Python 2)
# PYTHON_LIBRARIES := boost_python36 python3.6
# PYTHON_INCLUDE := /usr/include/python3.6 \
#                  /usr/lib/python3.6/dist-packages/numpy/core/include
sed -i 's/boost_python38/boost_python36/' Makefile.config
sed -i 's/python3\.8/python3\.6/' Makefile.config
sed -i 's/# WITH_PYTHON_LAYER := .*/WITH_PYTHON_LAYER := 1/' Makefile.config


# ===
# LIBRARY_DIRS
sed -i 's/x86_64-linux-gnu/aarch64-linux-gnu/' Makefile.config


# ===
# src/caffe/util/io.cpp:17:10: fatal error: turbojpeg.h: No such file or directory
# OK libturbojpeg
# sudo apt-get -y install libturbojpeg libturbojpeg-dev
sudo apt-get -y install libturbojpeg libturbojpeg0-dev
ls -l /usr/lib/aarch64-linux-gnu/libturbojpeg.so


# ===
# Build
echo "Make Caffe."
cp $SCRIPT_DIR/../Caffe/make_Caffe.sh .
chmod +x ./make_Caffe.sh
bash ./make_Caffe.sh


# ./.build_release/tools/caffe -version
# caffe version 0.17.4

# ===
# python -c "import caffe; print(caffe.__version__)"
# Err or 0.17.4
# python3 -c "import caffe; print(caffe.__version__)"
# Err or 0.17.4


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

