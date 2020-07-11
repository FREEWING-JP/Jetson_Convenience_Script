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
  echo "Need OpenCV v3.x/v4.x"
  exit 0
fi

echo $OPENCV_VERSION
if [[ ${OPENCV_VERSION} =~ ^([0-9]+)\..*$ ]]; then
  echo ${BASH_REMATCH[1]}
  case "${BASH_REMATCH[1]}" in
      "3")
        echo "OpenCV v3.x"
        OPENCV_VERSION=3
        OpenCV_DIR=/usr/local/share/OpenCV
        ;;
      "4")
        echo "OpenCV v4.x"
        OPENCV_VERSION=4
        OpenCV_DIR=/usr/local/lib/cmake/opencv4
        ;;
      *)
        echo "Need OpenCV v3.x/v4.x"
        exit 1
        ;;
  esac

  ls -l ${OpenCV_DIR}

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
# // NVCaffe May 1, 2019 v0.17.3 fd6cf7a
# NVCaffe Oct 29, 2019 caffe-0.17 17e347e
git clone https://github.com/NVIDIA/caffe nvcaffe --depth 1 -b caffe-0.17
cd nvcaffe

if [ $OPENCV_VERSION = 3 ]; then
  echo "Caffe OpenCV 3.x patch"

  # Copy Makefile.config
  cp Makefile.config.example Makefile.config
  # Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)

  # Edit Makefile.config
  # nano Makefile.config

  sed -i 's/^# USE_CUDNN/USE_CUDNN/' Makefile.config
  # sed -i 's/BLAS :=.*/BLAS := atlas/' Makefile.config
  sed -i 's/x86_64-linux-gnu/aarch64-linux-gnu/' Makefile.config
  sed -i 's/# OPENCV_VERSION/OPENCV_VERSION/' Makefile.config
  sed -i 's/# WITH_PYTHON_LAYER/WITH_PYTHON_LAYER/' Makefile.config

  # ===
  # ===
  tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
  echo $tegra_cip_id

  # Jetson Xavier NX
  if [ $tegra_cip_id = "25" ]; then
    # Jetson Xavier NX sm_72
    # CUDA_ARCH := -gencode arch=compute_72,code=sm_72 \
    #                -gencode arch=compute_72,code=compute_72
    sed -i 's/arch=compute_50,code=sm_50/arch=compute_72,code=sm_72/' Makefile.config
    sed -i 's/arch=compute_50,code=sm_50 \\/arch=compute_72,code=compute_72/' Makefile.config
    sed -i '/arch=compute_50,code=sm_50 \\/d' Makefile.config
    sed -i '/arch=compute_52,code=sm_52 \\/d' Makefile.config
    sed -i '/arch=compute_60,code=sm_60 \\/d' Makefile.config
    sed -i '/arch=compute_61,code=sm_61 \\/d' Makefile.config
    sed -i '/arch=compute_70,code=sm_70 \\/d' Makefile.config
    sed -i '/arch=compute_75,code=sm_75 \\/d' Makefile.config
    sed -i '/arch=compute_75,code=compute_75/d' Makefile.config
  fi

  # Jetson Nano
  if [ $tegra_cip_id = "33" ]; then
    # Jetson Nano sm_53
    sed -i 's/arch=compute_50,code=sm_50 \\/arch=compute_53,code=sm_53/' Makefile.config
    # sed -i 's/-gencode arch=compute_20,code=sm_21 \\//' Makefile.config
    # Makefile.config:41: *** recipe commences before first target.  Stop.
    sed -i '/arch=compute_50,code=sm_50 \\/d' Makefile.config
    sed -i '/arch=compute_52,code=sm_52 \\/d' Makefile.config
    sed -i '/arch=compute_60,code=sm_60 \\/d' Makefile.config
    sed -i '/arch=compute_61,code=sm_61 \\/d' Makefile.config
    sed -i '/arch=compute_70,code=sm_70 \\/d' Makefile.config
    sed -i '/arch=compute_75,code=sm_75 \\/d' Makefile.config
    sed -i '/arch=compute_75,code=compute_75/d' Makefile.config
  fi

fi

if [ $OPENCV_VERSION = 4 ]; then
  echo "Caffe OpenCV 4.x patch"

  # Copy Makefile.config
  cp $SCRIPT_DIR/open_cv4_patch/Makefile.config.example Makefile.config

  # Copy OpenCV v4.x patch
  cp $SCRIPT_DIR/open_cv4_patch/Makefile .
  cp $SCRIPT_DIR/open_cv4_patch/common.hpp ./include/caffe/
  cp $SCRIPT_DIR/open_cv4_patch/common_cv4.hpp ./include/caffe/
  cp $SCRIPT_DIR/open_cv4_patch/video_data_layer.cpp ./src/caffe/layers/

fi

# ===
# OpenBlas
sed -i 's/^BLAS :=.*/BLAS := open/' Makefile.config


# ===
# Install Dependencies
# Makefile.config
sudo apt-get -y install protobuf-compiler libprotoc-dev libboost-dev libgflags-dev libgoogle-glog-dev libhdf5-dev libleveldb-dev liblmdb-dev libopencv-dev libsnappy-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev libboost-python-dev python-skimage python-protobuf python-numpy python-pil

# libboost-regex-dev
sudo apt-get -y install libboost-regex-dev

# ===
# BLAS
grep "^BLAS := open" Makefile.config
if [ $? = 0 ]; then
  # OpenBLAS, BLAS := open
  sudo apt-get -y install libopenblas-base libopenblas-dev
else
  # ATLAS, BLAS := atlas
  sudo apt-get install libatlas-base-dev
fi


# ===
# src/caffe/util/io.cpp:17:10: fatal error: turbojpeg.h: No such file or directory
# OK libturbojpeg
# sudo apt-get -y install libturbojpeg libturbojpeg-dev
sudo apt-get -y install libturbojpeg libturbojpeg0-dev
ls -l /usr/lib/aarch64-linux-gnu/libturbojpeg.so


# ===
# Build
echo "Make Caffe."
echo "========== time make -j$(nproc)"
make clean

time make all -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

# ./.build_release/tools/caffe -version
# caffe version 0.17.3


echo "========== time make test -j$(nproc)"
# make test make runtest
time make test -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

echo "========== time make runtest -j$(nproc)"
time make runtest -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

# Python Caffe distribute
make pycaffe
make distribute
sudo ldconfig


# export CAFFE_HOME=/home/user/nvcaffe
export CAFFE_HOME=$(pwd)

echo ${CAFFE_HOME}
# /home/jetson/nvcaffe

ls -l ${CAFFE_HOME}/python
ls -l ${CAFFE_HOME}/distribute/lib

#
export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH
export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH


# ===
# add Caffe environment variable
echo "export CAFFE_HOME=${CAFFE_HOME}" >> ~/.bashrc
echo 'export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH' >> ~/.bashrc


# ===
python -c "import caffe; print(caffe.__version__)"
# Err or 0.17.3
python3 -c "import caffe; print(caffe.__version__)"
# Err or 0.17.3


# ===
# NVIDIA OpenPose
echo ${CAFFE_HOME}
# /home/jetson/nvcaffe

# NVIDIA OpenPose (NVCaffe)
# fatal error half_float/half.hpp No such file or directory
cp -r ${CAFFE_HOME}/3rdparty/* ${CAFFE_HOME}/include
# */

# fatal error caffe/proto/caffe.pb.h No such file or directory
cd ${CAFFE_HOME}
protoc src/caffe/proto/caffe.proto --cpp_out=.
mkdir include/caffe/proto
mv src/caffe/proto/caffe.pb.h include/caffe/proto

# ===
echo "export CAFFE_HOME=${CAFFE_HOME}"
echo 'export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH'
echo 'export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH'
echo "type 'source ~/.bashrc'"
echo ''
echo "source ~/.bashrc"
echo 'echo ${CAFFE_HOME}'
echo ''


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

