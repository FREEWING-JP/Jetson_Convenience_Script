#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/nvcaffe_cv4 ]; then
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
  if [ ! "${BASH_REMATCH[1]}" = "4" ]; then
    echo "Need OpenCV v4.x"
    exit 0
  fi
fi


# ===
# ===
# NVIDIA/caffe Git clone
cd
# clone NVCaffe
# // NVCaffe May 1, 2019 v0.17.3 fd6cf7a
# NVCaffe Oct 29, 2019 caffe-0.17 17e347e
git clone https://github.com/NVIDIA/caffe nvcaffe_cv4 --depth 1 -b caffe-0.17
cd nvcaffe_cv4


# ===
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


# Copy Makefile.config
cp $SCRIPT_DIR/open_cv4_patch/Makefile.config.example Makefile.config

# Copy OpenCV v4.x patch
cp $SCRIPT_DIR/open_cv4_patch/Makefile .
cp $SCRIPT_DIR/open_cv4_patch/common.hpp ./include/caffe/
cp $SCRIPT_DIR/open_cv4_patch/common_cv4.hpp ./include/caffe/
cp $SCRIPT_DIR/open_cv4_patch/video_data_layer.cpp ./src/caffe/layers/


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
# Err
python3 -c "import caffe; print(caffe.__version__)"
# 0.17.3


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

